class Tipologia < ActiveRecord::Base

  belongs_to :matrice

  has_many :rapporti, :dependent => :destroy
  has_many :campioni, :through => :rapporti

  has_many :prova_tipologia_items, :dependent => :destroy, :order => 'position ASC'
  has_many :prove, :through => :prova_tipologia_items


  # cancellando una tipologia, cancello anche l'elemento :prova_tipologia_item
  # per ora va bene, ma poi dovrò bloccare la cancellazione nel caso ci siano rapporti/campioni che prevedano questa tipologia
  #record is destroyed if before_destroy returns true.
  before_destroy :cancella_pure_dato_che_non_e_utilizzata
  after_destroy { |record| logger.info( "Tipologia '#{record.nome}' (id:#{record.id}) eliminata." ) }



  validates_presence_of :matrice, :nome
  validates_uniqueness_of :nome, :case_sensitive => false, :scope => :matrice_id # unico nome per prova su ogni matrice
  validates_numericality_of :prezzo, :greater_than_or_equal_to => 0, :if => :forfeit,
                              :message => 'deve essere presente se per Tipologie a forfeit'
  validates_numericality_of :prezzo, :if => :forfeit, :less_than => 100*1000,  #memorizziamo cents!
                              :message => 'deve essere minore di 1000€'
  validates_numericality_of :prezzo, :equal_to => 0, :unless => :forfeit,
                              :message => 'deve essere assente per Tipologie non a forfeit'

  def prezzo=(euro)
    write_attribute(:prezzo, euro.to_f * 100) # we store cents in the database
  end
  def prezzo
    read_attribute(:prezzo) / 100
  end

  def nome=(testo)
    # metto sempre l'iniziale maiuscola e levo spazi prima e dopo
    unless testo.nil?
      # non usare "strip!", usa invece "strip"
      testo = testo.to_s.strip
      testo = (testo.slice(0,1)).upcase+(testo.slice(1..-1)).to_s
    end
    write_attribute(:nome, testo)
  end

  def to_label
    "#{nome}" # come richiesto da giusy
#    if matrice.nil?
#      "#{nome}"
#    else
#      "#{matrice.nome}-#{nome}"
#    end
  end

  def cancella_pure_dato_che_non_e_utilizzata
    if !self.utilizzata?
      return true
    else
       raise "Non posso cancellare una tipologia se questa viene utilizzata"
      return false
    end
  end

  def utilizzata?
    if self.rapporti.empty?
      return false
    else
      return true
    end
  end

  def prove_ordinate
    # purtroppo abbiamo che, mentre self.prova_tipologia_items restituisce le prove ordinate per :position
    # self.prove non fa altrettanto, quindi è necessaria la seguente
    prove_ordinate = Array.new
    self.prova_tipologia_items.each {|prova_tipologia_item| prove_ordinate << prova_tipologia_item.prova }
    return prove_ordinate
  end

  def prezzo_automatico
    # mi serve per conoscere automaticamente il prezzo di una tipologia, a prescindere dal fatto che sia forfeit o no
    risultato = 0
    if self.forfeit
      risultato = self.prezzo
    else
      self.prove.each do |prova|
        risultato += prova.prezzo
      end
    end
    return risultato
  end

  def validate
    errors.add "Errore:", "Tipologia non modificabile in quanto risultà già utilizzata" if self.utilizzata?
  end

end
