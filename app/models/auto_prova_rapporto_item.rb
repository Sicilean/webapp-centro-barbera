class AutoProvaRapportoItem < ActiveRecord::Base

  belongs_to :prova
  belongs_to :rapporto

  validates_presence_of :rapporto_id
  validates_uniqueness_of :prova_id, :scope => :rapporto_id,
                          :message => 'prova automatica già presente per questo rapporto'

  before_destroy :cancella_pure_dato_che_non_e_fatturato


  def cancella_pure_dato_che_non_e_fatturato
    return !self.fatturato?
  end
  
  def fatturato?
    if self.rapporto.fatturato?
      return true
    else
      return false
    end
  end


  def prezzo=(euro)
    write_attribute(:prezzo, euro.to_f * 100) # we store cents in the database
  end
  def prezzo
    read_attribute(:prezzo) / 100
  end
  def prezzo_di_listino
    self.prova.prezzo
  end
  def to_label
    "#{self.prova.nome unless self.prova.nil?}"
  end

  def validate
    # la seguente non è proprio necessaria se tutto è regolare, in quanto le auto-prove dipendono dalla tipologia del rapporto (e tale tipologia non varia se il rapporto è fatturato)
    errors.add "Errore:", "Prova non modificabile in quanto legata ad un rapporto già fatturato" if self.fatturato?
  end

end
