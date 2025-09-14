class Prova < ActiveRecord::Base

  belongs_to :matrice
  #
  # NB cancellando la prova, mi cancella l'elemento :prova_variabile_items: per ora può andare, ma poi metto un vincolo
  # che NON possa cancellare le prove utilizzate da:
  #   - qualche repporto/campione
  #   - qualche tipologia
  has_many :prova_variabile_items, :dependent => :destroy
  has_many :variabili, :through => :prova_variabile_items
  #
  has_many :prova_tipologia_items, :dependent => :destroy
  has_many :tipologie, :through => :prova_tipologia_items
  #
  has_many :prova_rapporto_items, :dependent => :destroy
  has_many :rapporti, :through => :prova_rapporto_items

  # la seguente non servirebbe (la uso solo nel controllo per la cancellazione)
  has_many :auto_prova_rapporto_items, :dependent => :destroy
  #has_many :auto_prove, :through => :auto_prova_rapporto_items

  # il seguente metodo restituisce 'false' per Prova.destroy nel caso la prova sia utilizzata (nelle tipologia per ora)
  before_destroy :cancella_pure_dato_che_non_e_utilizzata
  after_destroy { |record| logger.info( "Prova '#{record.matrice.nome}-#{record.nome}' (id:#{record.id}) eliminata." ) }

  validates_presence_of :matrice, :nome

  validates_uniqueness_of :nome,  :case_sensitive => false, :scope => :matrice_id # unico nome per prova su ogni matrice

  validates_numericality_of :prezzo, :greater_than_or_equal_to => 0, :less_than => 10*100*100, #memorizziamo cents!
                              :message => 'deve essere minore di 1000€'


  def prezzo=(euro)
    write_attribute(:prezzo, euro.to_f * 100) # we store cents in the database
  end
  def prezzo
    read_attribute(:prezzo) / 100
  end


  def to_label
    if matrice.nil?
      "#{nome}"
    else
      "#{matrice.nome}-#{nome}"
    end
  end

  def cancella_pure_dato_che_non_e_utilizzata
    if !self.utilizzata?
      return true
    else
       # il seguente errore non viene fuori in activescaffold, ma la sua presenza viene segnalata da messaggi in inglese
       add_to_base "La Prova non puo' essere cancellata in quanto utilizzata"
       # nemmeno questo va... mah..
       logger.info( "Tentativo di cancellazione della prova '#{matrice.nome}-#{nome}' (id:#{id}) andato a vuoto in quanto la prova è utilizzata." )
      return false
    end
  end

  def almeno_una_tipologia_che_la_contiene_viene_utilizzata
    almeno_una_tipologia_viene_utilizzata = false
    self.tipologie.each {|tipologia| almeno_una_tipologia_viene_utilizzata = true if tipologia.utilizzata?}
    return almeno_una_tipologia_viene_utilizzata
  end

  def utilizzata?
    # attento ..il controllo di almeno_una_tipologia_che_la_contiene_viene_utilizzata è necessario per rapporti con tipologia senza prove automatiche e senza prove aggiuntive (in corso di lavorazione ad esempio)
    if self.prova_tipologia_items.empty? && self.prova_rapporto_items.empty? && self.auto_prova_rapporto_items.empty? && !self.almeno_una_tipologia_che_la_contiene_viene_utilizzata
      return false
    else
      return true
    end
  end

  def modificabile?
    # si può modificare anche se è utilizzata, a patto che lo sia fuori dai rapporti
    if self.utilizzata?
      if self.prova_rapporto_items.empty? && self.auto_prova_rapporto_items.empty? && !self.almeno_una_tipologia_che_la_contiene_viene_utilizzata
        #allora siamo sicuri che non ha niente a che vedere con i rapporti (ovvero è utilizzata solo causa !self.prova_tipologia_items.empty?)
        return true
      else
        return false
      end
    else
      return true
    end
  end

  def validate
    errors.add "Errore:", "Prova non modificabile in quanto risultà già utilizzata" if !self.modificabile?
  end

end
