class Rapporto < ActiveRecord::Base
  # tipologia_campione_items

  belongs_to :tipologia
  belongs_to :campione
  belongs_to :fattura

  has_many :prova_rapporto_items, :dependent => :destroy, :order => 'position ASC'
  has_many :prove, :through => :prova_rapporto_items

  has_many :auto_prova_rapporto_items, :dependent => :destroy, :order => 'id ASC'

  has_many :variabile_rapporto_items, :dependent => :destroy
  has_many :variabili, :through => :variabile_rapporto_items

  # Define virtual columns for ActiveScaffold to prevent nil errors
  def dati_rapporto_link
    nil  # This will be handled by the helper method
  end
  
  def stampa_dati_link
    nil  # This will be handled by the helper method
  end
  
  def stampa_rapporto_link
    nil  # This will be handled by the helper method
  end
  
  def duplica_rapporto_link
    nil  # This will be handled by the helper method
  end
  
  def fattura_link
    nil  # This will be handled by the helper method
  end

#  has_many :fattura_rapporto_items, :dependent => :destroy, :order => 'updated_at DESC'
#  has_many :fatture, :through => :fattura_rapporto_items

  # cancellando un rapporto potrei trovarmi con una fattura senza
  #record is destroyed if before_destroy returns true.
  before_destroy :cancella_pure_dato_che_non_ha_fattura

  def after_destroy
    self.pdf_elimina_tutto_a_seguito_cancellazione_rapporto
  end

  validates_presence_of :anno,
                        :unless => Proc.new { |rapporto| rapporto.numero.nil? },
                        :message => "Rdp deve essere presente visto che hai inserito il numero Rdp"
  validates_presence_of :numero,
                        :unless => Proc.new { |rapporto| rapporto.anno.nil? },
                        :message => "Rdp deve essere selezionato visto che hai inserito l'anno Rdp"

  validates_uniqueness_of :numero, 
                          :allow_nil => true,
                          #:scope => 'anno',
                          :scope => [:anno, :numero_supplemento],
                          :message => "è già in uso per l'anno selezionato"

  validates_numericality_of :numero,
                            :only_integer => true,
                            :allow_nil => true
                          
  validates_inclusion_of  :numero,
                          :in => 1..10000,
                          :allow_nil => true,
                          :message => 'deve essere compreso tra 1 e 9999 (o assente)'

  validates_presence_of :data_richiesta
  validates_presence_of :tipologia_id, :campione_id
  
  def before_create
    self.status = RAPPORTO_STATUS_DEFAULT
  end
#  def before_update
#    self.set_proper_status
#  end

  def before_save
    #
    # aggiorna_prezzo
    #
    # questo è il prezzo della SOLA tipologia (che raccoglie tante prove)
    # se è già fissato non lo modifico (visto che la tipologia NON cambia)
    # TODO manca BLOCCARE il prezzo, se questo è stato posto di proposito pari a zero
    # n.b. che se il prezzo della tipologia è pari a zero (frequente per tipologie senza prove) la seguente non fa nulla (riassegna semmai lo zero)
    if !self.tipologia.nil? && self.prezzo_tipologia_forfeit == 0 && self.tipologia.forfeit
#      if self.tipologia.forfeit
#        nuovo_prezzo = self.tipologia.prezzo
#      else
#        # somma analisi
#        nuovo_prezzo = 0
#        self.tipologia.prove.each{|prova| nuovo_prezzo += prova.prezzo}
#      end
#      self.prezzo = nuovo_prezzo
      if self.id.nil?
        # il record ancora non esiste (siamo in NEW)
        tipologia = Tipologia.find_by_id(self.tipologia.id)
        unless tipologia.nil?
          self.prezzo_tipologia_forfeit = Tipologia.find_by_id(self.tipologia.id).prezzo
        end
      else
        self.prezzo_tipologia_forfeit = self.tipologia.prezzo
      end
    end
  end

  # ogni volta che lo salvo, sincronizzo le sue variabili
  # e DOPO NON OCCORRE CHE AGGIORNO lo status dato che la TIPOLOGIA non cambia (e le sue variabili)
  # e qui lo status è già 'in lavorazione' in fase di creazione
  # semmai devo aggiornare lo status quando aggiungo o tolgo prove
  def after_save
    # ok la seguente after_save, visto che non modifica il self.
    self.sincronizza_variabile_rapporto_items
    # NO --andrebbe in loop! self.update_status
    #
    # Ora faccio in modo che si sincronizzi il database con i prezzi delle prove_non_aggiuntive
    self.sincronizza_auto_prova_rapporto_items
  end

  def fatturato?
    if self.fattura
      return true
    else
      return false
    end
  end

  def cancella_pure_dato_che_non_ha_fattura
    if self.fatturato?
      raise "Non posso cancellare, devi prima cancellare la relativa fattura"
      return false
    else
      return true
    end
  end

  def set_proper_status
    # qui non vado a controllare i dati, ma solo a vedere
    # se l'utente mi ha aggiunto o modificato delle prove
    # nel qual caso da 'completo' deve tornare ad essere 'in lavorazione'
    # ma attenzione.. devo ancora creare le variabili.. quindi non posso ancora andare a vedere le variabili mancanti
    # ovvero non posso andare a controllare self.variabili_tutte_inserite?
    # in ogni caso... il cambio da incompleto a completo non deve avvenire qui, ma in fase di inserimento dato
    # quindi basta la seguente
    if self.status == 'completo' && self.prove_totali.size == 0
        self.status = RAPPORTO_STATUS_DEFAULT
    end
  end

  def prezzo_tipologia_forfeit=(euro)
    write_attribute(:prezzo_tipologia_forfeit, euro.to_f * 100) # we store cents in the database
  end
  def prezzo_tipologia_forfeit
    value = read_attribute(:prezzo_tipologia_forfeit)
    value.nil? ? 0 : value / 100
  end

  def to_label
    # come richiesto da giusy (anche se lei aveva chiesto questa modifica solo nella tabella 'campioni')
    "#{'Rdp '+self.numero.to_s unless self.numero.blank?}-#{self.tipologia.nome unless self.tipologia.nil?}"
    #  "#{self.campione.to_label unless self.campione.nil?}-#{'Rdp '+self.numero.to_s unless self.numero.blank?}-#{self.tipologia.nome unless self.tipologia.nil?}"
  end

  def label_per_fattura
    "#{self.to_label} #{self.data_stampa.strftime("%d-%m-%y") unless self.data_stampa.nil?} €#{self.prezzo_totale}"
  end

  def cliente
    self.campione.cliente
  end

#  def fattura
#    if self.fatture.nil?
#      nil
#    else
#      self.fatture[0]
#    end
#  end

  def variabile_rapporto_items_mancanti
    self.variabile_rapporto_items.map{|variabile_rapporto_item| variabile_rapporto_item if variabile_rapporto_item.manca?}.compact
  end

  def variabili_tutte_inserite?
   self.variabile_rapporto_items_mancanti.empty?
  end

  def completo?
    self.status == 'completo'
  end
 
  def rdp_pronto?
    (self.status == 'completo') && !self.numero.blank? && self.variabili_tutte_inserite?
  end

  def aggiorna_data_di_stampa_se_mancante
    # occhio che è senza validazione
    self.update_attribute(:data_stampa, Time.now) if self.data_stampa.nil?
  end
#  def data_completamento
#    if self.variabili_tutte_inserite?
#      data = nil
#      self.variabile_rapporto_items.each do |variabile_rapporto_item|
#        unless variabile_rapporto_item.data.nil?
#          data = variabile_rapporto_item.data if (data == nil || data < variabile_rapporto_item.data)
#        end
#      end
#      return data
#    end
#  end
  # PROVE
  # il totale delle prove per rapporto è dato da rapporto.tipologia.prove + rapporto.prove (ke sono le prove aggiunte)
  def prove_totali
    # attenzione all'ordine: prima le prove della tipologia, poi le altre
    # le prove al loro interno sono già restituite ordinate per position
    return self.tipologia.prove + self.prove #.uniq non serve, dato che controllo a priori...levo le doppie (ke comunque non dovrebbero esserci)
  end

  def prove_ordinate
    # purtroppo abbiamo che, mentre self.prova_rapporto_items restituisce le prove ordinate per :position
    # self.prove non fa altrettanto, quindi è necessaria la seguente
    prove_ordinate = Array.new
    self.prova_rapporto_items.each {|prova_rapporto_item| prove_ordinate << prova_rapporto_item.prova }
    return prove_ordinate
  end

  def prove_totali_ordinate
    return self.tipologia.prove_ordinate + self.prove_ordinate
  end

  def sincronizza_variabile_rapporto_items
    # ricavo la lista delle variabili da aggiungere a variabile_rapporto_items
    # nb
    # rapporto.prove[0].variabili    sono le variabili che devo visualizzare del rapporto
    variabili_da_aggiungere = self.prove_totali.map {|prova| prova.variabili}.flatten.uniq##
    # e le variabili che devo calcolare!?!?!?!?
    # devo aggiungere tutte le variabili che sono incluse nella formule
    variabili_da_aggiungere += variabili_da_aggiungere.map{|variabile| variabile.variabili_coinvolte}.flatten.uniq
    variabili_da_aggiungere.uniq!
    # se in variabile_rapporto_items ci sono altre variabili oltre a quelle previste, le cancello
    self.variabili.each {|variabile| VariabileRapportoItem.first(:conditions => {:rapporto_id => self.id, :variabile_id => variabile.id}).destroy unless variabili_da_aggiungere.include? variabile}
    # ricavo le variabili da aggiungere che non sono state ancora aggiunte
    variabili_da_aggiungere.map!{|variabile| variabile unless self.variabili.include? variabile}
    variabili_da_aggiungere.compact! # levo i nil!
    # aggiungo le variabili a variabile_rapporto_items
    variabili_da_aggiungere.each{|variabile| VariabileRapportoItem.create(:variabile => variabile, :rapporto => self)}
  end

  def sincronizza_auto_prova_rapporto_items
#    # ricavo la lista delle prove da aggiungere ad auto_prova_rapporto_items
#    prove_da_aggiungere = self.tipologia.prove
#    # se in auto_prova_rapporto_items ci sono altre prove oltre a quelle previste, le cancello
#    self.auto_prove.each {|prova| AutoProvaRapportoItem.first(:conditions => {:rapporto_id => self.id, :prova_id => prova.id}).destroy unless prove_da_aggiungere.include? prova}
#    # ricavo le prove da aggiungere che non sono state ancora aggiunte
#    prove_da_aggiungere.map!{|prova| prova unless self.auto_prove.include? prova}
#    prove_da_aggiungere.compact! # levo i nil!
#    # aggiungo le prove a auto_prova_rapporto_items
#    prove_da_aggiungere.each{|prova| AutoProvaRapportoItem.create(:prova => prova, :rapporto => self, :prezzo => prova.prezzo)}

   # NB la tipologia NON cambia mai!!! quindi se non ci sono le auto prove, le creo.... stop
   if !self.tipologia.prove.empty? && self.auto_prova_rapporto_items.empty?
     self.tipologia.prove.each do |prova|
       if tipologia.forfeit?
         prezzo = 0
       else
         prezzo = prova.prezzo
       end
       AutoProvaRapportoItem.create(:prova => prova, :rapporto => self, :prezzo => prezzo)
     end
   end
  end

  def calcola
    # passo in rassegna tutte le  variabile_rapporto_items che sono funzione e ne ricavo e ne eseguo l'EVAL
    #self.
    self.variabile_rapporto_items.each {|variabile_rapporto_item| variabile_rapporto_item.calcola if variabile_rapporto_item.variabile.tipo == 'funzione'}
    self.update_status
  end

  def validate
    if !self.data_esecuzione_prove_fine.nil? and  self.data_esecuzione_prove_fine < self.data_esecuzione_prove_inizio
      errors.add :data_esecuzione_prove_fine, "deve essere posteriore alla data di inizio esecuzione prove"
    end
    if !self.data_esecuzione_prove_fine.nil? and  (self.data_esecuzione_prove_fine - self.data_esecuzione_prove_inizio) > 25
      errors.add :data_esecuzione_prove_fine, "risulta troppo distante dalla data di inizio esecuzione prove: correggi."
    end
    # salta questa validazione nel caso in cui il campione (o la tipologia) non ci sia (tanto lo intercetto comunque l'errore)
    unless self.campione.nil?
      unless self.campione.rapporti.empty?
        unless self.tipologia.nil?
         errors.add :tipologia, "ha matrice diversa da quella dei rapporti precedenti su questo campione" if self.tipologia.matrice != self.campione.rapporti[0].tipologia.matrice
        end
      end
    end
  end

  def update_status
    # questo metodo si esegue alla fine di self.calcola,
    # per aggiornare lo status e vedere se il rapporto è completo
    # 
    # se il rapporto è in lavorazione, controllo se nel frattempo è stato completato
    if self.status != 'completo'
      if (self.prove_totali.size >0 && self.variabili_tutte_inserite?)
        self.update_attribute(:status, 'completo')
      end
    else
      # se invece è completo, controllo ne nel frattempo non siano state cancellate le prove
      # nel qual caso deve tornare ad essere 'in lavorzione'
      if self.prove_totali.size  == 0
        self.update_attribute(:status, RAPPORTO_STATUS_DEFAULT)
      # se invece è completo, controllo a sua volta che nel frattempo non siano state aggiunte delle prove, oppure
      # non siano stati cancellati dei valori... nel qual caso torna ad essere 'in lavorazione'
      elsif !self.variabili_tutte_inserite?
        self.update_attribute(:status, RAPPORTO_STATUS_DEFAULT)
      end
    end
  end

  def invia_sms_per_rapporto_e_restituisce_errori(message, recipient, sender)
    status_errori = invia_sms_e_restituisce_errori(message, recipient, sender)
    if status_errori.nil?
      # invio corretto
      return nil
    else
      return status_errori
    end
  end

  def pdf_esiste?
    if self.anno.blank? || self.numero.blank?
      return false
    else
      nome_file = self.nome_file_pdf_del_rapporto_con_path_assoluto
      return File.exist?(nome_file)
    end
  end

  def pdf_backup_esiste?
    File.exist?(self.nome_file_pdf_del_rapporto_di_backup_con_path_assoluto)
  end
  def pdf_genera
    # non posso metterlo nel modello in quanto ha bisogno di una chiamata render !
  end

  def pdf_elimina
    if !self.anno.blank? && !self.numero.blank?
      nome_file = self.nome_file_pdf_del_rapporto_con_path_assoluto
      if File.exist?(nome_file)
        #File.delete(nome_file)
        # nb        File.basename("/home/gumby/work/ruby.rb", ".rb")   #=> "ruby"
        nome_file_backup = self.nome_file_pdf_del_rapporto_di_backup_con_path_assoluto # => 'Rdp_2010_1007.bak.pdf'
        if File.exist?(nome_file_backup)
          File.delete(nome_file_backup)
        end
        File.rename(nome_file, nome_file_backup)
      end
    end
  end

  def pdf_elimina_tutto_a_seguito_cancellazione_rapporto
    # il seguente non e' strettamente necessario, ma mi serve per evitare un controllo per pdf comunque non esistenti
    unless self.numero.blank?
      nome_file = self.nome_file_pdf_del_rapporto_con_path_assoluto
      if File.exist?(nome_file)
        File.delete(nome_file)
      end
      nome_file_backup = self.nome_file_pdf_del_rapporto_di_backup_con_path_assoluto
      if File.exist?(nome_file_backup)
        File.delete(nome_file_backup)
      end
    end
    return true
  end

  def nome_file_pdf_del_rapporto
    # il controllo è commentato: non puoi ASSOLUTAMENTE mettere un raise qui
#    if self.anno.blank? || self.numero.blank?
#      raise "Errore: stai tentando di salvare un PDF senza anno o numero di Rdp. Avvertire Francesco"
#    else
      return "Rdp_#{self.anno}_#{self.numero}#{('_s_'+self.numero_supplemento.to_s) unless self.numero_supplemento.blank?}.pdf"
#    end
  end

  def nome_file_pdf_del_rapporto_con_path_assoluto
    File.join(DIRECTORY_ASSOLUTA_PDF_RAPPORTI, self.nome_file_pdf_del_rapporto)
  end

  def nome_file_pdf_del_rapporto_di_backup_con_path_assoluto
    File.join(DIRECTORY_ASSOLUTA_PDF_RAPPORTI,File.basename(self.nome_file_pdf_del_rapporto_con_path_assoluto, '.pdf')+'.bak.pdf' ) # => 'Rdp_2010_1007.bak.pdf'
  end

  # PREZZO
  #
  # il segreto per capire è che:
  # ---- rapporto.prova_rapporto_items contiene le PROVE AGGIUNTIVE, e NON tutte le prove di un rapporto
  # ---- rapporto.prove è lo stesso, contiene le PROVE AGGIUNTIVE, e NON tutte le prove di un rapporto
  # difatti  le RAPPORTI.prove_totali = self.tipologia.prove + self.prove #
  #  la differenza tra rapporto.prove e rapporto.prove_rapporto_items è che il promo ha elementi della classe PROVE (il cui .prezzo è di listino)
  #  mentre rapporto.prove_rapporto_items ha elementi di classe diversa, il cui .prezzo è il prezzo EFFETTIVO.
  #
  #
  # Il prezzo di un rapporto è di tue tipi
  #
  # PREZZO TOTALE  DI LISTINO = rapporto.tipologia.prezzo_automatico + rapporto.prove.each {|prova| prezzo_tot += prova.prezzo}
  #
  # PREZZO TOTALE  EFFETTIVO = rapporto.prezzo                                    + rapporto.prova_rapporto_items.each {|prova_rapporto_item| prezzo_tot += prova_rapporto_item.prezzo}


  # self.prezzo = prezzo effettivo delle sole prove incluse nella self.tipologia (senza cioè le prove aggiuntive)
  # self.prezzo_di_listino = come sopra ma con il prezzo di listino
  # self.prezzo_totale = prezzo effettivo del rapporto (inclusi i prezzi delle prove aggiuntive)
  # self.prezzo_totale_di_listino = come sopra ma con il prezzo di listino

  def prezzo_tipologia_automatico
    if self.tipologia.forfeit
      self.prezzo_tipologia_forfeit
    else
      self.prezzo_auto_prove
    end
  end
  
  def prezzo_auto_prove
    if self.tipologia.forfeit
      return self.prezzo_tipologia_forfeit
    else
      prezzo_tot = 0
      self.auto_prova_rapporto_items.each {|auto_prova_rapporto_item| prezzo_tot += auto_prova_rapporto_item.prezzo}
      return prezzo_tot
    end
  end

  def prezzo_auto_prove_di_listino
    if self.tipologia.forfeit
      return self.tipologia.prezzo
    else
      prezzo_tot = 0
      self.auto_prova_rapporto_items.each {|auto_prova_rapporto_item| prezzo_tot += auto_prova_rapporto_item.prezzo_di_listino}
      return prezzo_tot
    end
  end

  def prezzo_prove_aggiuntive
    prezzo_tot = 0
    self.prova_rapporto_items.each{|prova_rapporto_item| prezzo_tot += prova_rapporto_item.prezzo}
    return prezzo_tot
  end

  def prezzo_prove_aggiuntive_di_listino
    prezzo_tot = 0
    self.prova_rapporto_items.each{|prova_rapporto_item| prezzo_tot += prova_rapporto_item.prezzo_di_listino}
    return prezzo_tot
  end

#  def prezzo_di_listino
#    # attenzione che è il prezzo SENZA le prove aggiuntive
#    self.tipologia.prezzo_automatico
#  end

  def prezzo_totale
#    #
#    # IMPORTANTE
#    # rapporto.prezzo = prezzo del rapporto SENZA il prezzo delle prove aggiuntive; ed è pari al prezzo della tipologia (nel caso del forfeit) oppure alla somma dei prezzi delle analisi
#    #   quindi per calcolare il prezzo totale si deve sommare a questo il prezzo delle prove aggiuntive
#    #
#    prezzo_tot = self.prezzo
#    # aggiungo l'eventuale costo delle prove aggiuntive
#    self.prova_rapporto_items.each{|prova_rapporto_item| prezzo_tot += prova_rapporto_item.prezzo}
#    return prezzo_tot
    return self.prezzo_auto_prove + self.prezzo_prove_aggiuntive
  end

  def prezzo_totale_di_listino
#    prezzo_tot = self.prezzo_di_listino
#    #self.prova.each{|prova| prezzo_tot += prova.prezzo}
#    self.prova_rapporto_items.each{|prova_rapporto_item| prezzo_tot += prova_rapporto_item.prezzo_di_listino}
#    return prezzo_tot
    return self.prezzo_auto_prove_di_listino + self.prezzo_prove_aggiuntive_di_listino
  end

  def attualizza_prezzo # e restituisco true in caso il prezzo abbia subito modifiche
    # la seguente aggiorna il prezzo al listino attuale
    if self.fattura || (self.prezzo_totale == self.prezzo_totale_di_listino)
      # salto i rapporti con fattura presente, o con prezzo già aggiornato
      return false
    else
      if self.tipologia.forfeit
        self.update_attribute(:prezzo_tipologia_forfeit, self.tipologia.prezzo)
        self.auto_prova_rapporto_items.each do |auto_prova_rapporto_item|
          auto_prova_rapporto_item.update_attribute(:prezzo, 0)
        end
      else
        self.update_attribute(:prezzo_tipologia_forfeit, 0)
        self.auto_prova_rapporto_items.each do |auto_prova_rapporto_item|
          auto_prova_rapporto_item.update_attribute(:prezzo, auto_prova_rapporto_item.prezzo_di_listino)
        end
      end
      self.prova_rapporto_items.each do |prova_rapporto_item|
        prova_rapporto_item.update_attribute(:prezzo, prova_rapporto_item.prezzo_di_listino)
      end
      return true
    end
  end

  # PREZZO PER FATTURA
  #
  # ovviamente il prezzo di un rapporto per la fattura è rapporto.prezzo_totale (che può essere diverso da rapporto.prezzo_totale_di_listino)
  # ma massimiliano vuole la possibilità di MODIFICARE i prezzi in fase di fatturazione; ora... siccome sarebbe bene CONSERVARE i prezzi così modificati la
  # domanda è:  quali sono i prezzi che gli posso far modificare?
  #
  # * il prezzo effettivo di ogni prova aggiuntiva
  # * il prezzo della tipologia (che sia forfeit oppure no)
  # ...ma non riesco a memorizzare i prezzi delle prove incluse nella tipologia nel caso si tratti di somma analisi....
  # ecco che quando viene creata una fattura per un certo cliente, se si tratta di tipologie o prove aggiuntive già fatturate a quel cliente si 
  # potrebbe farne vedere il prezzo a suo tempo fatturato
  #
  # per memorizzare questi prezzi NON devo inserire nuovi campi, ma vado ad aggiornare gli attuali.... ma DEVO ACCERTARMI di NON AGGIORNARE MAI questi dati
  # nel caso esista una fattura

  def validate
    errors.add "Errore:", "Rapporto non modificabile in quanto risultà già fatturato" if self.fatturato?
  end
end
