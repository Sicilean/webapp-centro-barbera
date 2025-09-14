class VariabileRapportoItem < ActiveRecord::Base

  belongs_to :variabile
  belongs_to :rapporto

#  def before_save
#    self.data = Time.now
#  end

  # controllo che non sia già fatturato
  def before_destroy
    if self.fatturato?
      return false
    else
      return true
    end
  end

  validates_presence_of :rapporto_id, :variabile_id
  validates_numericality_of  :valore_numero, :allow_nil => true
  # un solo di variabile per ciascun rapporto
  # TODO a regime abilita la seguente
  validates_uniqueness_of :variabile_id, :scope => :rapporto_id,
                          :message => 'già presente nel rapporto (qualcosa non funzione, questo non dovrebbe mai accadere)'

  def to_label
    "#{self.rapporto.numero unless self.rapporto.nil?}-#{self.variabile.nome unless self.variabile.nil?}"
  end

  def data
    return self.updated_at.to_date
  end
  def fatturato?
    if self.rapporto.fatturato?
      return true
    else
      return false
    end
  end

  def udm
    self.variabile.udm_item.nome unless self.variabile.udm_item.nil?
  end

  def variabile_tipo
    self.variabile.tipo
  end

  def ok?
    # è ok solo se è presente il valore
    # e quindi può essere utilizzato nella formula
    case self.variabile.tipo
    when 'funzione'
      if valore_numero.nil?
        return false
      else
        return true
      end
    when 'input-valore'
      if valore_numero.nil?
        return false
      else
        return true
      end
    when 'input-testo'
      if valore_testo.blank?
        return false
      else
        return true
      end
    end
  end

  def manca?
    # i dati mancanti sono quelli che devono essere inseriti (quindi no funzioni!)
    case self.variabile.tipo
    when 'funzione'
      return false
    when 'input-valore'
      if valore_numero.nil?
        return true
      else
        return false
      end
    when 'input-testo'
      if valore_testo.blank?
        return true
      else
        return false
      end
    end
  end
#  def calcola_vecchio
#    if self.variabile.tipo == 'funzione'
#      # nella funzione_sviluppata sostituisco i simboli con i valori
#      funzione = ''
#      funzione.replace self.variabile.funzione_sviluppata
#      #funzione = self.variabile.funzione_sviluppata.clone
#      simboli_mancanti = 0
#      funzione.gsub!(/[A-Z]{1,4}/) do |simbolo|
#        # get_variabile(simbolo, matrice)
#        variabile_da_sostituire = get_variabile(simbolo,self.rapporto.tipologia.matrice)
#        variabile_rapporto_item = VariabileRapportoItem.first(:conditions => ["rapporto_id = ? AND variabile_id = ?", self.rapporto.id, variabile_da_sostituire.id])
#        if variabile_rapporto_item.ok?
#          da_sostituire = "#{variabile_rapporto_item.valore_numero}"
#        else
#          simboli_mancanti +=1
#          da_sostituire = simbolo
#        end
#        da_sostituire
#      end
#      # se la funzione che rimane contiene simboli non calcolo
#      if simboli_mancanti > 0
#        self.update_attribute(:errore, "Errore: #{simboli_mancanti} simboli mancanti")
#      else
#        begin
#          risultato = eval funzione
#        rescue  => detail
#          self.update_attribute(:errore, detail.message)
#        else
#          self.update_attribute(:valore_numero, risultato)
#          self.update_attribute(:errore, nil)
#        end
#      end
#      # se non contiene simboli faccio l'eval
#      # intercetto eventuale errore e lo metto nel campo 'errore'
#    end
#  end
  def calcola
    if self.variabile.tipo == 'funzione'
      # nella funzione_sviluppata sostituisco i simboli con i valori
      funzione = ''
      funzione.replace self.variabile.funzione_sviluppata
      #funzione = self.variabile.funzione_sviluppata.clone
      simboli_mancanti = 0
      funzione.gsub!(/[A-Z]{1,4}/) do |simbolo|
        # get_variabile(simbolo, matrice)
        variabile_da_sostituire = get_variabile(simbolo,self.rapporto.tipologia.matrice)
        variabile_rapporto_item = VariabileRapportoItem.first(:conditions => ["rapporto_id = ? AND variabile_id = ?", self.rapporto.id, variabile_da_sostituire.id])
        variabile_rapporto_item.calcola
        if variabile_rapporto_item.ok?
          da_sostituire = "#{variabile_rapporto_item.valore_numero}"
        else
          simboli_mancanti +=1
          da_sostituire = simbolo
        end
        da_sostituire
      end
      # se la funzione che rimane contiene simboli non calcolo
      if simboli_mancanti > 0
        self.update_attribute(:errore, "#{simboli_mancanti} simboli mancanti")
      else
        begin
          risultato = eval funzione
        rescue  => detail
          self.update_attribute(:errore, detail.message)
        else
          self.update_attribute(:valore_numero, risultato)
          self.update_attribute(:errore, nil)
        end
      end
      # se non contiene simboli faccio l'eval
      # intercetto eventuale errore e lo metto nel campo 'errore'
    end
  end

def valore_automatico
  if self.variabile.tipo == 'input-testo'
    self.valore_testo
  else
    if self.valore_numero_forzato.nil?
      my_number_with_precision(self.valore_numero, :precision => self.variabile.decimali).to_s # to_s non necessario, ma messo per restituire sempre stringa
    else
      my_number_with_precision(self.valore_numero_forzato, :precision => self.variabile.decimali).to_s # to_s non necessario, ma messo per restituire sempre stringa
    end
  end
end

  def validate
# la seguente non è necessaria, ma non si sa mai
    errors.add "Errore:", "Prova non modificabile in quanto legata ad un rapporto già fatturato" if self.fatturato?
  end
  
end
