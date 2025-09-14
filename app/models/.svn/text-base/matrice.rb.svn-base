class Matrice < ActiveRecord::Base

  has_many :prove, :dependent => :destroy # cancello la matrice, e cancello anche le sue prove SALVO EVENTUALI BLOCCHI
  has_many :tipologie, :dependent => :destroy # cancello la matrice, e cancello anche le sue tipologie SALVO EVENTUALI BLOCCHI
  #has_many :variabili

  # DEDOTTA
  has_many :variabili # questa già la si sapeva
  # la seguente da escludere, visto che ci possono essere variabili senza udm_items
  #has_many :udm_items, :through => :variabili



  #record is destroyed if before_destroy returns true.
  before_destroy :cancella_pure_dato_che_non_e_utilizzata
  after_destroy { |record| logger.info( "Matrice '#{record.nome}' (id:#{record.id}) eliminata." ) }

  validates_presence_of :nome
  validates_uniqueness_of :nome, :case_sensitive => false

  def to_label
    "#{nome}"
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


  def cancella_pure_dato_che_non_e_utilizzata
    if !self.utilizzata?
      return true
    else
       raise "Non posso cancellare una matrice se questa viene utilizzata"
      return false
    end
  end

  def utilizzata?
    if self.variabili.empty? && self.prove.empty? && self.tipologie.empty?
      return false
    else
      return true
    end
  end

  def validate
    errors.add "Errore:", "Matrice non modificabile in quanto risultà già utilizzata" if self.utilizzata?
  end

end
