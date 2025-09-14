class ProvaVariabileItem < ActiveRecord::Base

  belongs_to :prova
  belongs_to :variabile

  validates_presence_of :prova_id, :variabile_id
  # un solo tipo di variabile per ciascuna prova
  validates_uniqueness_of :variabile_id, :scope => :prova_id,
                          :message => 'già presente nella specifica Prova'

  before_destroy :cancella_pure_dato_che_non_e_utilizzata

  def prezzo=(euro)
    write_attribute(:prezzo, euro.to_f * 100) # we store cents in the database
  end
  def prezzo
    read_attribute(:prezzo) / 100
  end

  def to_label
    "#{self.variabile.nome unless self.variabile.nil?}"
  end

  def cancella_pure_dato_che_non_e_utilizzata
    if !self.utilizzata?
      return true
    else
       # il seguente errore non viene fuori in activescaffold, ma la sua presenza viene segnalata da messaggi in inglese
       add_to_base "Prova_variabile non puo' essere cancellata in quanto utilizzata"
       # nemmeno questo va... mah..
       logger.info( "Tentativo di cancellazione della prova_variabile (id:#{id}) andato a vuoto in quanto è utilizzata." )
      return false
    end
  end

  def utilizzata?
    if self.prova.utilizzata?
      return true
    else
      return false
    end
  end


  def modificabile?
    # senza questo controllo non era comunque possibile AGGIUNGERE variabili alla prova,
    # ma tuttavia si riusciva a CANCELLARLE (anche se il programma dava errore).
    # ecco che quindi aggiungo qui un controllo
    #
    if self.prova.modificabile?
      return true
    else
      return false
    end
  end

  protected

  def validate
    errors.add 'La Variabile'," deve essere della stessa matrice della prova (#{prova.matrice.nome})" unless prova.matrice == variabile.matrice
    errors.add "Errore:", "Prova_Variabile non modificabile in quanto risultà già utilizzata" if !self.modificabile?
  end


end
