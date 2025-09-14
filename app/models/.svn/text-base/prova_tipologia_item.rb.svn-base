class ProvaTipologiaItem < ActiveRecord::Base

  belongs_to :prova
  belongs_to :tipologia

  before_destroy :cancella_pure_dato_che_non_e_utilizzata


#
# AVVERTENZA
# in questo modello, per conservare l'ordinamento delle prove
# ho dovuto fare in modo che i record venissero salvati anche nel caso in cui la prova sia inesistente serf.prova.nil?
# dato che il campo 'position' è sempre compilato
# poi, una volta salvato, viene distrutto se la prova è nulla
# e poi, ancora una volta, dopo essere stato distrutto, non si procede ad alcuna sincronizzazione
# ...sarebbe tutto migliorabile, ma ho speso 8 ore per arrivare fino a qui!
#

# appena creata la prova aggiuntiva, sincronizzo il rapporto
  def after_save
    if self.prova.nil?
      # ho salvato una prova balorda
      self.destroy
#    else
#      self.tipologia.sincronizza_variabile_tipologia_items
#      # ma ora ATTENZIONE... la tipologia ha ancora le variabili vecchie... devo RICARICARLO!!!!
#      self.tipologia.reload
#      self.tipologia.update_status
    end
  end
  # quando cancello la prova aggiuntiva, devo sincronizzarne la tipologia
#  def after_destroy
#    if self.prova.nil?
#      # ho distrutto una prova balorda ... ke va cancellata senza altre azioni
##    else
##      # ho appena cancellato il record dal DB, ma... è ancora in memoria (mitico rails!)
##      self.tipologia.sincronizza_variabile_tipologia_items
##       # ma ora ATTENZIONE... la tipologia ha ancora le variabili vecchie... devo RICARICARLO!!!!
##      self.tipologia.reload
##      self.tipologia.update_status
#    end
#  end

  validates_presence_of :tipologia_id
  # la seguente commentata per ammettere 'balordi'
  #validates_presence_of :prova_id
  validates_uniqueness_of :prova_id, :scope => :tipologia_id,
                          :message => 'già presente nella specifica Tipologia Rdp'

  def to_label
    "#{self.tipologia.nome unless self.tipologia.nil?}"
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
    if self.tipologia.utilizzata?
      return true
    else
      return false
    end
  end

  protected

  def validate
    errors.add "Errore:", "Non modificabile in quanto risultà già utilizzata" if self.utilizzata?
    unless prova.nil?
      errors.add 'La Prova'," deve essere della stessa matrice della tipologia (#{tipologia.matrice.nome})" unless prova.matrice == tipologia.matrice
    end
  end

end
