class UdmItem < ActiveRecord::Base


  # DEDOTTA
  has_many :variabili # questa già la si sapeva
  # la seguente mi pare serva a ben poco (comunque...)
  has_many :matrici, :through => :variabili

  before_destroy :cancella_pure_dato_che_non_e_utilizzata

  validates_presence_of :nome
  validates_uniqueness_of :nome, :case_sensitive => false

  def to_label
    "#{nome}"
  end

  def cancella_pure_dato_che_non_e_utilizzata
    if !self.utilizzata?
      return true
    else
       raise "Non posso cancellare una unita' di misura se è utilizzata"
      return false
    end
  end

  def utilizzata?
    if self.variabili.empty?
      return false
    else
      return true
    end
  end

  def validate
    errors.add "Errore:", "Unità di misura non modificabile in quanto risultà già utilizzata da delle variabili" if self.utilizzata?
  end

end
