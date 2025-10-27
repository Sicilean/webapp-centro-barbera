class Variabile < ActiveRecord::Base

  belongs_to :udm_item
  belongs_to :matrice
  #
  has_many :prova_variabile_items, :dependent => :destroy
  has_many :prove, :through => :prova_variabile_items

  has_many :variabile_rapporto_items, :dependent => :destroy
  has_many :rapporti, :through => :variabile_rapporto_items

  before_validation :pulisci_funzione
  # il seguente metodo restituisce 'false' per Variabile.destroy nel caso la variabile sia utilizzata
  before_destroy :cancella_pure_dato_che_non_e_utilizzata
  after_destroy { |record| logger.info( "Variabile '#{record.matrice.nome}-#{record.simbolo}' (id:#{record.id}) eliminata." ) }

  # la seguente viene levata in quanto le unità di misura ci sono solo per le variabili da mostrare
  # validates_presence_of :udm_item
  
  validates_presence_of :nome, :simbolo, :tipo, :matrice
  validates_presence_of :funzione, :if => :is_funzione?,
                        :message => 'deve essere presente per il tipo selezionato'
  validates_inclusion_of :funzione, :in => ['', nil], :if => :is_input?,
                        :message => 'NON deve essere presente per il tipo selezionato'
  validates_presence_of :decimali, :if => :is_funzione?,
                        :message => 'deve essere selezionato per il tipo selezionato'
  # serve a poco, ma lasciamolo
  validates_numericality_of  :min, :max, :allow_nil => true

  # TODO la seguente è errata in quando Variabile non ha un valore di matrice_id DIRETTO
  #  validazione unicità di :simbolo, :nome all'interno di una stessa matrice
  #validates_uniqueness_of :nome, :case_sensitive => false, :scope => :matrice_id # unico nome per prova su ogni matrice
  validates_uniqueness_of :simbolo, :case_sensitive => false, :scope => :matrice_id


  def to_label
    if matrice.nil?
      "#{simbolo}-#{nome}"
    else
      "#{matrice.nome}-#{simbolo}-#{nome}"
    end
  end


  def simbolo=(testo)
    testo = testo.upcase unless testo.nil?
    write_attribute(:simbolo, testo)
  end

  def pulisci_funzione
    if self.funzione.nil? # il blank lascialo per la seguente
      self.funzione = ''
    else
      # levo spazi dappertutto
      self.funzione.gsub!(/\s/,'')
      # levo eventuale segno di '=' (MA solo all'inizio, così uno si accorge se ha messo l'uguale al posto di altro)
      self.funzione.gsub!(/^=/,'')
      # tutto maiuscolo
      self.funzione.upcase!
      # sostituisco 'virgola' con 'punto' (all'inglese)
      self.funzione.gsub!(/,/,'.')
      # sostituisco elevatore potenza excel "^" con quello di ruby "**"
      self.funzione.gsub!(/\^/,'**')
      # tolgo tutti i numeri di 1,2 cifre che siano preceduti da una o due lettere
      # prendo la prima occorrenza di una o due lettere ed uno o due numer AANNi
      re = /[A-Z]{1,4}[0-9]{1,2}/
      self.funzione =~   re # ora $& = 'B12'
      unless $&.nil?
        # in "23+B12" prendo '12'
        numero = $&.sub!(/[A-Z]{1,4}/,'') # numero = '12'
        # sostituisco le coppie AANN con AA
        self.funzione.gsub!(re) {|match| match.delete numero}
      end
    end
  end
#  def funzione_corretta
#    testo = funzione
#    # le operazioni qui sotto vengono fatte PRIMA della validazione (che entra in gioco con il write_attribute (!)
#    if testo.nil?
#      testo = ''
#    else
#      # levo spazi dappertutto
#      testo.gsub!(/\s/,'')
#      # levo eventuale segno di '=' (MA solo all'inizio, così uno si accorge se ha messo l'uguale al posto di altro)
#      testo.gsub!(/^=/,'')
#      # tutto maiuscolo
#      testo.upcase!
#      # sostituisco 'virgola' con 'punto' (all'inglese)
#      testo.gsub!(/,/,'.')
#      # sostituisco elevatore potenza excel "^" con quello di ruby "**"
#      testo.gsub!(/\^/,'**')
#      # tolgo tutti i numeri di 1,2 cifre che siano preceduti da una o due lettere
#      # prendo la prima occorrenza di una o due lettere ed uno o due numer AANNi
#      re = /[A-Z]{1,2}[0-9]{1,2}/
#      testo =~   re # ora $& = 'B12'
#      unless $&.nil?
#        # in "23+B12" prendo '12'
#        numero = $&.sub!(/[A-Z]{1,2}/,'') # numero = '12'
#        # sostituisco le coppie AANN con AA
#        testo.gsub!(re) {|match| match.delete numero}
#      end
#    end
#  end
#  def funzione_ok
#    unless funzione_corretta.blank?
#      n_parentesi_aperte = (funzione_corretta.gsub  /[^(]/, '').length
#      n_parentesi_chiuse = (funzione_corretta.gsub  /[^)]/, '').length
#      if !(n_parentesi_aperte == n_parentesi_chiuse) ||
#         !((funzione_corretta =~ /[^-A-Z0-9()*\/+.]/).nil?) ||
#         !((funzione_corretta =~ /[+-\/]{2,}/).nil?) ||
#         !((funzione_corretta =~ /[*]{3,}/).nil?)
#      return "ERRORE"
#      end
#    end
#  end

  def is_funzione?
    tipo == 'funzione'
  end

  def is_input?
    !is_funzione?
  end

  def unita_di_misura
    udm_item.nome unless udm_item.nil?
  end

  def simboli
    # restituisce array con simboli utilizzati
    # non serve controllare che sia funzione
    return simboli_per_funzione(funzione)
  end

  def variabili_indipendenti_con_assenti
    # restituisce un array di classe Variabile, con valori nil per elementi assenti
    # gli elementi assenti sono quelli presenti nella formula ma ASSENTI nel DB
    return simboli.map {|simbolo| get_variabile(simbolo,matrice)}
  end

  def variabili_indipendenti
    # vendono escluse le variabili indipendenti della sviluppata
    return variabili_indipendenti_con_assenti.compact
  end

  def variabili_coinvolte_in_words
    begin
      return variabili_coinvolte.map{|x| "<#{x.simbolo}>"}.to_s
    rescue ZeroDivisionError, StandardError => e
      return "[ERRORE: #{e.message}]"
    end
  end

  def variabili_indipendenti_in_words
      variabili_indipendenti.each {|x| risultato += x.simbolo+', '}
  end  
  
  def variabili_indipendenti_tutte_presenti?
    return variabili_indipendenti_con_assenti.size == variabili_indipendenti.size
  end

  def variabili_indipendenti_assenti
    unless variabili_indipendenti_tutte_presenti?
      return (simboli - variabili_indipendenti.map {|variabile| variabile.simbolo })
    end
  end

  def variabili_in_cui_viene_utilizzata
    # controlla ANCHE le funzioni, in quanto possono essere utilizzate a sua volta come variabili indipendenti
    #
    # cerca tutte le variabili che sono funzioni della stessa matrice, per vedere se la variabile da cancellare è utilizzata
    variabili = Variabile.all(:conditions => ["tipo= ? AND matrice_id = ?", 'funzione', self.matrice.id])
    # nella seguente uso variabile.simboli che è + performante che variabile.variabili_indipendenti
    variabili_che_la_utilizzano = []
    variabili.each {|variabile| variabili_che_la_utilizzano << variabile if ((variabile.id != self.id) && (variabile.simboli.include? self.simbolo)) }
    return variabili_che_la_utilizzano
  end

  def viene_utilizzata_in_altre_variabili?
    variabili_in_cui_viene_utilizzata.empty?
  end

  def cancella_pure_dato_che_non_e_utilizzata
    if !self.utilizzata?
      return true
    else
       #errors.add 'La Variabile',"non puo' essere cancellata in quanto utilizzata"
       # il seguente errore non viene fuori in activescaffold, ma la sua presenza viene segnalata da messaggi in inglese
       add_to_base "La Variabile non puo' essere cancellata in quanto utilizzata"
       # nemmeno questo va... mah..
       logger.info("Tentativo di cancellazione della Variabile '#{matrice.nome}-#{simbolo}' (id:#{id}) andato a vuoto in quanto utilizzata.")
      return false
    end
  end

  def utilizzata?
    if self.variabili_in_cui_viene_utilizzata.empty? && self.prove.empty? && self.variabile_rapporto_items.empty?
      # non è necessario controllare che tutte le variabili_in_cui_viene_utilizzata non siano presenti in variabile_rapporto_items
      # visto che la cosa è automatica
      return false
    else
      return true
    end
  end

  def modificabile?
    # si può modificare anche se è utilizzata, a patto che lo sia fuori dai rapporti
    if self.utilizzata?
      if self.variabile_rapporto_items.empty?
        #allora siamo sicuri che non ha niente a che vedere con i rapporti (ovvero è utilizzata solo causa self.variabili_in_cui_viene_utilizzata.empty? && self.prove.empty? && )
        return true
      else
        return false
      end
    else
      return true
    end
  end

  def variabili_coinvolte
    # se A = B+2, B=D+5, allora A=D+7... ma anche la B è coinvolta!!!! e qui la ricaviamo
    if is_funzione?
      # inizio a pescare le variabili della formula
      risultato = variabili_indipendenti_per_funzione(funzione, matrice)
      nuova_funzione =''
      nuova_funzione.replace funzione # necessario, altrimenti in fase di validazione MODIFICO la funzione
      contatore = 0
      max_iterazioni = 100
      until variabili_indipendenti_che_sono_funzioni_per_funzione(nuova_funzione,matrice).empty? || contatore == max_iterazioni
        # fin tanto almeno una delle variabili indipendenti è una funzione
        # sostituisci la variabile indipendente funzione, con la sua funzione TRA PARENTESI
        variabili_indipendenti_che_sono_funzioni_per_funzione(nuova_funzione, matrice).each do |variabile|
          # sostituisco, ma solo per insieme di 1max2 lettere!!!attento!
          nuova_funzione.gsub!(/[A-Z]{1,4}/) do |match|
            if match == variabile.simbolo
              "(#{variabile.funzione})"
            else
              match
            end
          end
        end
        risultato += variabili_indipendenti_per_funzione(nuova_funzione, matrice)
        risultato.uniq!
        #
        # se non esco da questo loop significa che c'è un riferimento circolare!!!!
        contatore += 1
      end
      if contatore == max_iterazioni
        raise "Errore... non ci dovrebbe essere stato, ma siamo difronte ad un RIFERIMENTO CIRCOLARE"
      else
        return risultato
      end
    else
      return [] # mi server per poter fare variabili_coinvolte.map
    end
  end

  def funzione_sviluppata
    if is_funzione?
      begin
        nuova_funzione =''
        nuova_funzione.replace funzione # necessario, altrimenti in fase di validazione MODIFICO la funzione
        contatore = 0
        max_iterazioni = 100
        until variabili_indipendenti_che_sono_funzioni_per_funzione(nuova_funzione,matrice).empty? || contatore == max_iterazioni
          # fin tanto almeno una delle variabili indipendenti è una funzione
          # sostituisci la variabile indipendente funzione, con la sua funzione TRA PARENTESI
          variabili_indipendenti_che_sono_funzioni_per_funzione(nuova_funzione, matrice).each do |variabile|
            # sostituisco, ma solo per insieme di 1max2 lettere!!!attanto!
            nuova_funzione.gsub!(/[A-Z]{1,4}/) do |match|
              if match == variabile.simbolo
                "(#{variabile.funzione})"
              else
                match
              end
            end
          end
          #
          # se non esco da questo loop significa che c'è un riferimento circolare!!!!
          contatore += 1
        end
        if contatore == max_iterazioni
          # attento NON MODIFICARE la seguente che mi serve per la validazione
          return "**ERRORE** - RIFERIMENTO CIRCOLARE"
        else
          return nuova_funzione
        end
      rescue ZeroDivisionError, StandardError => e
        return "**ERRORE** - #{e.message}"
      end
    end
  end

  def funzione_decodificata
    begin
      return decodifica(funzione)
    rescue ZeroDivisionError, StandardError => e
      return "**ERRORE** - #{e.message}"
    end
  end

  def funzione_sviluppata_decodificata
    begin
      return decodifica(funzione_sviluppata)
    rescue ZeroDivisionError, StandardError => e
      return "**ERRORE** - #{e.message}"
    end
  end

  def decodifica(funzione_da_decodificare)
    unless funzione_da_decodificare.blank?
      return funzione_da_decodificare.gsub(/[A-Z]{1,4}/){|match| "<#{get_variabile(match,matrice).nome.strip}>"}
    end
  end
  
  #protected

  def validate

    errors.add "Errore:", "Prova non modificabile in quanto risultà già utilizzata" if !self.modificabile?

    errors.add :simbolo, "può contenere solo lettere, ma hai inserito un carattere non ammesso: '#$&'" unless (simbolo =~ /[^A-Z]/).nil?

    unless funzione.blank?
      # ATTENZIONE che PRIMA viene fatta la sostituzione come in 'funzione=' e poi viene fatto il controllo qui sotto
      # quindi non ci sono + gli =, le virgole, gli spazi ...
      # controllo coerenza funzione
      #
      # controllo numero parentesi: che il numero di quelle aperte combaci con quello di quelle chiuse
      n_parentesi_aperte = (funzione.gsub  /[^(]/, '').length
      n_parentesi_chiuse = (funzione.gsub  /[^)]/, '').length
      errors.add  :funzione, 'con numero di parentesi aperte è diverso dal numero di parentesi chiuse' unless n_parentesi_aperte == n_parentesi_chiuse
      #
      # controllo che ci siano solo '\d', '\w', '\.', '(', ')', + - * /
      errors.add :funzione, "contiene un carattere non ammesso: #$&" unless (funzione =~ /[^-A-Z0-9()*\/+.]/).nil?
      #
      # controlla che non ci siano RIPETIZIONI per +-/^.,
      # n.b. potresti anche usare /(\+)\1/ per il '+'
      errors.add :funzione, "contiene un operatore ripetuto: #$&" unless (funzione =~ /[+-\/]{2,}/).nil?
      # controllo che non ci siano + di due * consecutivi
      errors.add :funzione, "contiene un operatore ripetuto: #$&" unless (funzione =~ /[*]{3,}/).nil?
      #
      # controllo che i simboli non contengano più di due lettere consecutive
      errors.add :funzione, "contiene simboli che hanno più di sette lettere: #$&" unless (funzione =~ /[A-Z]{8,}/).nil?#
      # controllo che non siano rimaste delle coppie AB23
      # cosa ke può succedere se nella formula ho AB21+C21*AB23
      errors.add :funzione, "contiene un riferimento non valido: #$&" unless (funzione =~ /[A-Z]{1,4}[0-9]{1,2}/).nil?
      #
      # MANCA
      #
      # controlla la presenza di un operatore DOPO ciascuna parentesi chiusa, a meno che non sia l'ultima
      # oppure.... + semplice
      # sostituisci il valore 1.444 (meglio se periodico) a tutte le lettere e chiedi di fare il conto
      # se da errore significa che la formula è sbagliata :)
      #
      # nb. la radice quadrata si calcola con l'esponente: Radice(9) = 9^(1/2) = 9**(1/2.0)  ATTENZIONE ALLO ZERO!!
      # attenzione anche che 9+2/3 = 9 (!)
    end
    unless self.errors.size > 0
      #i controlli seguenti li facci solo se non ho altri errori
      if self.variabili_indipendenti_tutte_presenti?
        errors.add :funzione, 'contiene un riferimento circolare' if (is_funzione? && funzione_sviluppata.include?(ERRORE_TAG))
      else
        errors.add :funzione, 'contiene variabili non ancora definite: prima definisci le variabili coinvolte nella funzione, e poi la funzione. '
      end
    end
  end

end
