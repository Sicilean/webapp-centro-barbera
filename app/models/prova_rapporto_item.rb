class ProvaRapportoItem < ActiveRecord::Base

  belongs_to :prova
  belongs_to :rapporto

#
# AVVERTENZA
# in questo modello, per conservare l'ordinamento delle prove aggiuntive
# ho dovuto fare in modo che i record venissero salvati anche nel caso in cui la prova sia inesistente serf.prova.nil?
# dato che il campo 'position' è sempre compilato
# poi, una volta salvato, viene distrutto se la prova è nulla
# e poi, ancora una volta, dopo essere stato distrutto, non si procede ad alcuna sincronizzazione
# ...sarebbe tutto migliorabile, ma ho speso 8 ore per arrivare fino a qui!
#

  def before_save
    # aggiorna prezzo
    # n.b. la tabella ProvaRapporto contiene SOLO le prove aggiuntive, e non quelle già
    # incluse dalla scelta della tipologia.
    # vecchio: (self.prezzo = self.prova.prezzo) if (!self.rapporto.tipologia.forfeit && (self.prezzo == 0))
    # TODO manca BLOCCARE il prezzo, se questo è stato posto di proposito pari a zero
    # questo lo si fa se il rapporto non è stato fatturato
    #
    unless self.prova.nil?
      self.prezzo = self.prova.prezzo if self.prezzo == 0
    end
  end
  # appena creata la prova aggiuntiva, sincronizzo il rapporto
  def after_save
    if self.prova.nil?
      # ho salvato una prova balorda
      self.destroy
    else
      self.rapporto.sincronizza_variabile_rapporto_items
      # ma ora ATTENZIONE... il rapporto ha ancora le variabili vecchie... devo RICARICARLO!!!!
      self.rapporto.reload
      self.rapporto.update_status
    end
  end
  
  # controllo che non sia già fatturato
  before_destroy :cancella_pure_dato_che_non_e_fatturato

  # quando cancello la prova aggiuntiva, devo sincronizzarne il rapporto
  def after_destroy
    if self.prova.nil?
      # ho distrutto una prova balorda ... ke va cancellata senza altre azioni
    else
      # ho appena cancellato il record dal DB, ma... è ancora in memoria (mitico rails!)
      self.rapporto.sincronizza_variabile_rapporto_items
       # ma ora ATTENZIONE... il rapporto ha ancora le variabili vecchie... devo RICARICARLO!!!!
      self.rapporto.reload
      self.rapporto.update_status
    end
  end

  validates_presence_of :rapporto_id
  # la seguente commentata per ammettere 'balordi'
  #validates_presence_of :prova_id
  # un solo tipo di prova per ciascun rapporto
  validates_uniqueness_of :prova_id, :scope => :rapporto_id,
                          :message => 'già presente nel rapporto'


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
    errors.add "Errore:", "Prova non modificabile in quanto legata ad un rapporto già fatturato" if self.fatturato?
    unless prova.nil?
      errors.add :prova, "già inclusa tra le prove della tipologia" if self.rapporto.tipologia.prove.include? self.prova
      errors.add :prova, "relativa ad un'altra matrice" if self.rapporto.tipologia.matrice != self.prova.matrice
    end
  end

# la seguente è stata commentata (ed è pure sbagliata visto ke bisognerebbe levare il if !self.rapporto.tipologia.forfeit
#  def aggiorna_prezzo
#    update_attribute(:prezzo, self.prova.prezzo) if (!self.rapporto.tipologia.forfeit && (self.prezzo == 0))
#  end
end
