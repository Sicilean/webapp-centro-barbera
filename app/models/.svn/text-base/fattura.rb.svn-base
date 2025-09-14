class Fattura < ActiveRecord::Base

  belongs_to :cliente

  has_many :rapporti#  se aggiungessi ":dependent => :destroy" vorrebbe dire che quando  cancello la fattura, e cancello i suoi rapporti (NO)

#  has_many :fattura_rapporto_items, :dependent => :destroy
#  has_many :rapporti, :through => :fattura_rapporto_items

  def after_destroy
    self.cancella_fattura_id_nei_rapporti
    self.pdf_elimina_tutto_a_seguito_cancellazione_fattura
  end

  validates_presence_of :cliente, :numero, :anno, :data_inizio, :data_fine

  validates_uniqueness_of :numero,
                          :allow_nil => false,
                          :scope => 'anno',
                          :message => "è già in uso per l'anno selezionato"

  validates_numericality_of :numero,
                            :only_integer => true,
                            :allow_nil => false

  validates_inclusion_of  :numero,
                          :in => 1..10000,
                          :allow_nil => false,
                          :message => 'deve essere un numero intero e positivo'

  validates_inclusion_of  :sconto,
                          :in => 0..100,
                          :allow_nil => false,
                          :message => 'deve essere compreso tra 1 e 100'


#  def before_save
#    self.aggiorna_data_inizio_e_data_fine
#  end

  def after_create
    # Aggiungo i rapporti di quel cliente, non ancora fatturati, con data tra inizio e fine
    self.cliente.rapporti_fatturabili.each do |rapporto|
      if  !rapporto.data_stampa.nil? &&
                !self.data_inizio.nil? &&
                !self.data_fine.nil? &&
                rapporto.data_stampa >= self.data_inizio &&
                rapporto.data_stampa <= self.data_fine
        rapporto.update_attribute :fattura_id, self.id
      end
    end
#    # levo i rapporti non inclusi nell'intervallo
#    self.rapporti.each do |rapporto|
#      if  !rapporto.data_stampa.nil? &&
#                !self.data_inizio.nil? &&
#                !self.data_fine.nil? &&
#                (rapporto.data_stampa < self.data_inizio ||
#                rapporto.data_stampa > self.data_fine)
#        rapporto.update_attribute :fattura_id, nil
#      end
#    end
    # faccio in modo che AUTOMATICAMENTE quando ad una fattura vengono aggiunti dei rapporti:
    # - i prezzi (senza prove aggiuntive) dei rapporti di medesima tipologia siano gli stessi
    #  - i prezzi di medesime prove aggiuntive siano uguali
    # quale prezzo scelgo? il + basso (preservo l'eventuale sconto fatto)
#    self.allinea_i_prezzi_di_medesime_tipologie_al_prezzo_piu_basso
#    self.allinea_i_prezzi_di_medesime_prove_al_prezzo_piu_basso
    self.se_medesime_tipologie_hanno_prezzi_diversi_assegna_il_prezzo_di_listino
    self.se_medesime_prove_hanno_prezzi_diversi_assegna_il_prezzo_di_listino
#    # il seguente serve per fare automaticamente il refresh della lista
#    self.rapporti.each do |rapporto|
#      rapporto.prova_rapporto_items.reload
#      rapporto.prove.reload
#      rapporto.reload
#    end
#    self.reload
  end

  def cancella_fattura_id_nei_rapporti
    self.rapporti.each do |rapporto|
      rapporto.update_attribute(:fattura_id, nil)
    end
  end

  def to_label
    "#{self.numero}/#{self.data_emissione.year}"
  end

  def pagata?
    self.data_pagamento.nil? ? false : true
  end

  def completa?
    if self.rapporti.size > 0
      return true
    else
      return false
    end
  end

  def rapporti_ordinati_per_nome_tipologia
    self.rapporti.sort_by{|rapporto| rapporto.tipologia.nome_esteso}
  end
  
#  def prove_totali
#    # attenzione che sono solo le prove aggiuntive
#    prove_tot = Array.new
#    self.rapporti.each do |rapporto|
#      rapporto.prove.each do |prova|
#        prove_tot << prova
#      end
#    end
#    return prove_tot
#  end
  
  def tipologie
    tipologie_tot = Array.new
    self.rapporti.each do |rapporto|
      tipologie_tot << rapporto.tipologia
    end
    return tipologie_tot
  end

  def tipologie_a_forfeit
    tipologie_tot = Array.new
    self.rapporti.each do |rapporto|
      tipologie_tot << rapporto.tipologia if rapporto.tipologia.forfeit
    end
    return tipologie_tot
  end

  def tipologie_non_a_forfeit
    self.tipologie - self.tipologie_a_forfeit
  end

  def solo_rapporti_con_tipologia_del_tipo(tipologia)
    rapporti_tot = Array.new
    self.rapporti.each do |rapporto|
      rapporti_tot << rapporto if rapporto.tipologia == tipologia
    end
    return rapporti_tot
  end

  def numero_di_tipologie(tipologia)
    self.solo_rapporti_con_tipologia_del_tipo(tipologia).size
  end

  def prezzo_della_tipologia(tipologia)
    risultato = 0
    self.rapporti.each do |rapporto|
      if rapporto.tipologia == tipologia
        if tipologia.forfeit
          risultato = rapporto.prezzo_tipologia_forfeit
        else
          risultato = rapporto.prezzo_auto_prove           
        end
      end
      # attenzione che li giro tutti per niente, quando invece mi potrei fermare al primo
    end
    return risultato
  end

  def aggiorna_il_prezzo_della_tipologia(tipologia,prezzo)
    # nb. agisce SOLO sulle tipologie a forfeit
    self.rapporti.each do |rapporto|
      if rapporto.tipologia == tipologia
        if rapporto.tipologia.forfeit
        rapporto.update_attribute(:prezzo_tipologia_forfeit,prezzo)
        end
      end
    end
  end

  def aggiorna_il_prezzo_della_auto_prova(prova,prezzo)
    # n.b. agisce solo sulle tipologie NON a forfeit
    self.rapporti.each do |rapporto|
      rapporto.auto_prova_rapporto_items.each do |auto_prova_rapporto_item|
        if auto_prova_rapporto_item.prova == prova
          auto_prova_rapporto_item.update_attribute(:prezzo,prezzo)
        end
      end
    end
  end

  def allinea_i_prezzi_di_medesime_tipologie_al_prezzo_piu_basso
    prezzo_modificato = false
    self.tipologie.uniq.each do |tipologia|
      if tipologia.forfeit
        prezzo_piu_basso = self.solo_rapporti_con_tipologia_del_tipo(tipologia).sort_by{|rapporto| rapporto.prezzo_auto_prove}[0].prezzo_auto_prove
        self.solo_rapporti_con_tipologia_del_tipo(tipologia).each do |rapporto|
          if rapporto.prezzo_auto_prove != prezzo_piu_basso
            rapporto.update_attribute(:prezzo_tipologia_forfeit,prezzo_piu_basso)
            prezzo_modificato = true
          end
        end
      end
    end
    return prezzo_modificato
  end

  def se_medesime_tipologie_hanno_prezzi_diversi_assegna_il_prezzo_di_listino
    # N.b. vale solo per le tipologie a forfeit
    self.tipologie_a_forfeit.uniq.each do |tipologia|
        vettore_prezzi = self.solo_rapporti_con_tipologia_del_tipo(tipologia).map{|rapporto| rapporto.prezzo_tipologia_forfeit}.sort.uniq
        if vettore_prezzi.size > 1 # ho prezzi diversi per stesse tipologie
          self.solo_rapporti_con_tipologia_del_tipo(tipologia).each do |rapporto|
            if rapporto.prezzo_tipologia_forfeit != tipologia.prezzo
              rapporto.update_attribute(:prezzo_tipologia_forfeit, tipologia.prezzo)
            end
          end
        end
    end
  end

#  def prova_rapporto_items
#    prova_rapporto_items_tot = Array.new
#    self.rapporti.each do |rapporto|
#      rapporto.prova_rapporto_items.each do |prova_rapporto_item|
#        prova_rapporto_items_tot << prova_rapporto_item
#      end
#    end
#    return prova_rapporto_items_tot
#  end
#
#  def numero_di_prova_rapporto_items(prova_rapporto_item_da_contare)
#    contatore = 0
#    self.rapporti.each do |rapporto|
#      rapporto.prova_rapporto_items.each do |prova_rapporto_item|
#        contatore += 1 if  prova_rapporto_item == prova_rapporto_item_da_contare
#      end
#    end
#    return contatore
#  end

  def prove
    # ATTENZIONE CHE NON SONO LE PROVE TOTALI!!!!!!!!! ma solo le aggiuntive
    prove_tot = Array.new
    self.rapporti.each do |rapporto|
      rapporto.prove.each do |prova|
        prove_tot << prova
      end
    end
    return prove_tot
  end

  def prova_rapporto_items
    prova_rapporto_items_tot = Array.new
    self.rapporti.each do |rapporto|
      rapporto.prova_rapporto_items.each do |prova_rapporto_item|
        prova_rapporto_items_tot << prova_rapporto_item
      end
    end
    return prova_rapporto_items_tot
  end

  def auto_prova_rapporto_items
   auto_prova_rapporto_items_tot = Array.new
    self.rapporti.each do |rapporto|
      rapporto.auto_prova_rapporto_items.each do |auto_prova_rapporto_item|
        auto_prova_rapporto_items_tot << auto_prova_rapporto_item
      end
    end
    return auto_prova_rapporto_items_tot
  end

  def solo_prova_rapporto_items_con_prova_del_tipo(prova)
    prova_rapporto_items_tot = Array.new
    self.prova_rapporto_items.each do |prova_rapporto_item|
      prova_rapporto_items_tot << prova_rapporto_item if prova_rapporto_item.prova == prova
    end
    return prova_rapporto_items_tot    
  end

  def solo_auto_prova_rapporto_items_con_prova_del_tipo(prova)
    auto_prova_rapporto_items_tot = Array.new
    self.auto_prova_rapporto_items.each do |auto_prova_rapporto_item|
      auto_prova_rapporto_items_tot << auto_prova_rapporto_item if auto_prova_rapporto_item.prova == prova
    end
    return auto_prova_rapporto_items_tot
  end
  
  def numero_di_prove(prova)
    return solo_prova_rapporto_items_con_prova_del_tipo(prova).size
  end

  def prezzo_della_prova(prova)
    risultato = 0
    self.rapporti.each do |rapporto|
      rapporto.prova_rapporto_items.each do |prova_rapporto_item|
        (risultato = prova_rapporto_item.prezzo) if prova_rapporto_item.prova == prova
        # attenzione che li giro tutti per niente, quando invece mi potrei fermare al primo
      end
    end
    return risultato
  end

  def prezzo_della_auto_prova(prova)
    risultato = 0
    self.rapporti.each do |rapporto|
      rapporto.auto_prova_rapporto_items.each do |auto_prova_rapporto_item|
        (risultato = auto_prova_rapporto_item.prezzo) if auto_prova_rapporto_item.prova == prova
        # attenzione che li giro tutti per niente, quando invece mi potrei fermare al primo
      end
    end
    return risultato
  end

  def aggiorna_il_prezzo_della_prova(prova,prezzo)
    self.rapporti.each do |rapporto|
      rapporto.prova_rapporto_items.each do |prova_rapporto_item|
        if prova_rapporto_item.prova == prova
          prova_rapporto_item.update_attribute(:prezzo,prezzo)
        end
      end
    end
  end

  def allinea_i_prezzi_di_medesime_prove_al_prezzo_piu_basso
    # TODO pare prenda il più alto e non il più basso :(
    prezzo_modificato = false
    # PROVE AGGIUNTIVE
    self.prove.uniq.each do |prova|
      prezzo_piu_basso = self.solo_prova_rapporto_items_con_prova_del_tipo(prova).sort_by{|prova_rapporto_item| prova_rapporto_item.prezzo}[0].prezzo
       self.solo_prova_rapporto_items_con_prova_del_tipo(prova).each do |prova_rapporto_item|
        if prova_rapporto_item.prezzo != prezzo_piu_basso
          prova_rapporto_item.update_attribute(:prezzo,prezzo_piu_basso)
          prezzo_modificato = true
        end
      end
    end
    # PROVE AUTOMATICHE
    self.auto_prova_rapporto_items.uniq.each do |auto_prova_rapporto_item_da_aggiornare|
      prezzo_piu_basso = self.solo_auto_prova_rapporto_items_con_prova_del_tipo(auto_prova_rapporto_item_da_aggiornare.prova).sort_by{|auto_prova_rapporto_item| auto_prova_rapporto_item.prezzo}[0].prezzo
       self.solo_auto_prova_rapporto_items_con_prova_del_tipo(auto_prova_rapporto_item_da_aggiornare.prova).each do |auto_prova_rapporto_item|
        if auto_prova_rapporto_item.prezzo != prezzo_piu_basso
          unless auto_prova_rapporto_item.rapporto.tipologia.forfeit
            auto_prova_rapporto_item.update_attribute(:prezzo,prezzo_piu_basso)
            prezzo_modificato = true
          end
        end
      end
    end
    return prezzo_modificato
  end

  def se_medesime_prove_hanno_prezzi_diversi_assegna_il_prezzo_di_listino
    # PROVE AGGIUNTIVE
    self.prove.uniq.each do |prova|
      vettore_prezzi = self.solo_prova_rapporto_items_con_prova_del_tipo(prova).map{|prova_rapporto_item| prova_rapporto_item.prezzo}.sort.uniq
      if vettore_prezzi.size > 1 # ho prezzi diversi per stesse tipologie
      self.solo_prova_rapporto_items_con_prova_del_tipo(prova).each do |prova_rapporto_item|
          if prova_rapporto_item.prezzo != prova.prezzo
          prova_rapporto_item.update_attribute(:prezzo,prova.prezzo)
          end
        end
      end
    end
    # PROVE AUTOMATICHE
    self.auto_prova_rapporto_items.uniq.each do |auto_prova_rapporto_item_da_aggiornare|
      prova = auto_prova_rapporto_item_da_aggiornare.prova
      vettore_prezzi = self.solo_auto_prova_rapporto_items_con_prova_del_tipo(prova).map{|auto_prova_rapporto_item| auto_prova_rapporto_item.prezzo}.sort.uniq
      if vettore_prezzi.size > 1 # ho prezzi diversi per stesse tipologie
      self.solo_auto_prova_rapporto_items_con_prova_del_tipo(prova).each do |auto_prova_rapporto_item|
          if auto_prova_rapporto_item.prezzo != prova.prezzo
          auto_prova_rapporto_item.update_attribute(:prezzo,prova.prezzo)
          end
        end
      end
    end
  end

  #
  def totale_analisi_senza_prove_aggiuntive
    risultato = 0
    self.rapporti.each {|rapporto| risultato += rapporto.prezzo_auto_prove}
    return risultato
  end

  def totale_analisi
    risultato = 0
    self.rapporti.each {|rapporto| risultato += rapporto.prezzo_totale}
    return risultato
  end

  def totale_analisi_di_listino
    risultato = 0
    self.rapporti.each {|rapporto| risultato += rapporto.prezzo_totale_di_listino}
    return risultato
  end

  def sconto
    self.totale_analisi * self.percentuale_sconto/100
  end

  def imponibile
    # Base imponibile su cui si calcola l'IVA
    self.totale_analisi - self.sconto
  end

  def imposta
    self.imponibile * IVA # IVA = 0.20
  end

  def totale
    self.imposta + self.imponibile
  end


  def pdf_esiste?
    if self.anno.blank? || self.numero.blank?
      return false
    else
      nome_file = self.nome_file_pdf_della_fattura_con_path_assoluto
      return File.exist?(nome_file)
    end
  end

  def pdf_backup_esiste?
    File.exist?(self.nome_file_pdf_della_fattura_di_backup_con_path_assoluto)
  end
  def pdf_genera
    # non posso metterlo nel modello in quanto ha bisogno di una chiamata render !
  end

  def pdf_elimina
    if !self.anno.blank? && !self.numero.blank?
      nome_file = self.nome_file_pdf_della_fattura_con_path_assoluto
      if File.exist?(nome_file)
        #File.delete(nome_file)
        # nb        File.basename("/home/gumby/work/ruby.rb", ".rb")   #=> "ruby"
        nome_file_backup = self.nome_file_pdf_della_fattura_di_backup_con_path_assoluto # => 'Rdp_2010_1007.bak.pdf'
        if File.exist?(nome_file_backup)
          File.delete(nome_file_backup)
        end
        File.rename(nome_file, nome_file_backup)
      end
    end
  end

  def pdf_elimina_tutto_a_seguito_cancellazione_fattura
    # il seguente non e' strettamente necessario, ma mi serve per evitare un controllo per pdf comunque non esistenti
    unless self.numero.blank?
      nome_file = self.nome_file_pdf_della_fattura_con_path_assoluto
      if File.exist?(nome_file)
        File.delete(nome_file)
      end
      nome_file_backup = self.nome_file_pdf_della_fattura_di_backup_con_path_assoluto
      if File.exist?(nome_file_backup)
        File.delete(nome_file_backup)
      end
    end
    return true
  end

  def nome_file_pdf_della_fattura
    # il controllo è commentato: non puoi ASSOLUTAMENTE mettere un raise qui
#    if self.anno.blank? || self.numero.blank?
#      raise "Errore: stai tentando di salvare un PDF senza anno o numero di Rdp. Avvertire Francesco"
#    else
      return "Fattura_#{self.anno}_#{self.numero}.pdf"
#    end
  end

  def nome_file_pdf_della_fattura_con_path_assoluto
    File.join(DIRECTORY_ASSOLUTA_PDF_RAPPORTI, self.nome_file_pdf_della_fattura)
  end

  def nome_file_pdf_della_fattura_di_backup_con_path_assoluto
    File.join(DIRECTORY_ASSOLUTA_PDF_RAPPORTI,File.basename(self.nome_file_pdf_della_fattura_con_path_assoluto, '.pdf')+'.bak.pdf' ) # => 'Fattura_2010_1007.bak.pdf'
  end

  def indirizzo_automatico
    if self.usa_indirizzo_di_fatturazione
      if self.cliente.fatt_indirizzo.blank?
        self.cliente.indirizzo
      else
        self.cliente.fatt_indirizzo
      end
    else
      self.cliente.indirizzo
    end
  end

  def cap_automatico
    if self.usa_indirizzo_di_fatturazione
      if self.cliente.fatt_cap.blank?
        self.cliente.cap
      else
        self.cliente.fatt_cap
      end
    else
      self.cliente.cap
    end
  end

  def comune_automatico
    if self.usa_indirizzo_di_fatturazione
      if self.cliente.fatt_comune.blank?
        self.cliente.comune
      else
        self.cliente.fatt_comune
      end
    else
      self.cliente.comune
    end
  end

  def provincia_automatico
    if self.usa_indirizzo_di_fatturazione
      if self.cliente.fatt_provincia.blank?
        self.cliente.provincia
      else
        self.cliente.fatt_provincia
      end
    else
      self.cliente.provincia
    end
  end

  def validate
    errors.add :data_pagamento, "non può essere antecedente alla data di emissione" if !data_pagamento.nil? && (data_pagamento < data_emissione)
    errors.add :data_fine, "non può essere antecedente alla data di inizio"         if !data_fine.nil?       && (data_fine < data_inizio)
    errors.add :data_fine, "non può essere antecedente alla data di emissione"      if !data_fine.nil?       && (data_emissione < data_fine)
    errors.add :data_inizio, "non può essere antecedente alla data di emissione"    if !data_inizio.nil?      && (data_emissione < data_inizio)
  end


end
