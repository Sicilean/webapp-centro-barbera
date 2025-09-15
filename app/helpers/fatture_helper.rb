module FattureHelper

  def pagata_column(record)
    record.pagata? ? "Sì" : "No"
  end

  def percentuale_sconto_column(record)
    "#{record.percentuale_sconto}%"
  end

  def totale_column(record)
    "<b>#{formatta_prezzo record.totale}</b>"
  end

  def totale_analisi_column(record)
    # ATTENZIONE --- aggiunto il reload per risolvere rognosi problemi di refresh!!
    record.reload
    output = "#{formatta_prezzo record.totale_analisi}"
    if record.totale_analisi != record.totale_analisi_di_listino
      output += "<br/> <span style='color: #999;'><i>list.#{formatta_prezzo record.totale_analisi_di_listino}</i></span>"
    end
    return output
  end

  def dati_fattura_link_column(record)
#    if record.rapporti.size == 0
#      "<small>Senza rapporti</small> #{link_to 'Modifica', :controller => 'fatture', :action => 'edit', :id => record.id}"
#    else
      link_to 'Modifica Prezzi', :controller => :admin, :action => :dati_fattura, :id => record.id
#    end
  end

  def stampa_fattura_link_column(record)
#    if record.completa?
#      "#{link_to 'Fatt_'+record.numero.to_s,              :controller => :fatture, :action => :genera_pdf, :id => record.id, :format => :pdf}<br />"+
#      "#{link_to((image_tag 'pdf_icon.gif', :border => 0), :controller => :fatture, :action => :genera_pdf, :id => record.id, :format => :pdf)}"
#    else
#      "Fatt_#{record.numero}"
#    end
    if record.pdf_esiste?
      #"#{link_to 'Fattura_'+record.numero.to_s,                      :controller => :fatture, :action => :mostra_pdf, :id => record.id}<br />"+
      "#{link_to((image_tag 'pdf_icon.gif', :border => 0), :controller => :fatture, :action => :mostra_pdf, :id => record.id)}<br />"
    else
      "Fattura_#{record.numero}"
      "#{link_to 'Crea Pdf', :controller =>  :fatture, :action => :crea_pdf, :id => record.id }"

    end
  end

  def rigenera_pdf_link_column(record)
    if record.pdf_esiste?
      "#{link_to 'Rigenera Pdf', url_for(:controller =>  :fatture, :action => :crea_pdf, :id => record.id),  :confirm => 'Sei sicuro? questo comporterà la cancellazione del pdf precedente'}"
    end
  end

  def note_form_column(record, input_name)
    text_area :record, :note, :name => input_name, :cols => 80, :rows => 4
  end

  def usa_indirizzo_di_fatturazione_form_column(record, input_name)
    check_box :record, :usa_indirizzo_di_fatturazione, :name => input_name
  end

#  def cliente_column(record)
#  '<a href="/clienti/8/edit?_method=get&amp;parent_controller=fatture" class="edit action cliente" id="as_fatture-clienti-edit-8-link" position="after">Cassarà</a>'
#
##    link_to record.cliente.to_label, "clienti/8/edit?_method=get&parent_controller=fatture"
#  end
  
#  def rapporti_column(record)
#  '<a href="/rapporti/37/edit?_method=get&amp;parent_controller=fatture" class="edit action cliente" id="as_fatture-rapporti-edit-37-link" position="after">Rdp 201-C.Q. vino</a>'
##    link_to record.rapporti[0].to_label, record.rapporti[0]
#  end

#  def rapporti_column(record)
#    '<a href="/fatture/1/nested?_method=get&amp;associations=rapporti" class="nested action rapporti" id="as_fatture-rapporti-nested-1-link" position="after">RAPPORTI</a>'
#  end

  def cliente_form_column(record, input_name)
     if record.id.nil?
      if params[:cliente_id] && !Cliente.find(params[:cliente_id]).nil?
        clienti_da_mostrare = [Cliente.find(params[:cliente_id])]
        cliente_selezionato = params[:cliente_id].to_i
        aggiungi_cliente_vuoto = false
      else
        clienti_da_mostrare = Cliente.all # volendo potrei mostrare solo i clienti che hanno rapporti non pagati, e mostrare a fianco del nome il sospeso
        cliente_selezionato = record.cliente_id
        aggiungi_cliente_vuoto = true
      end
      campi_per_select = clienti_da_mostrare.map{|cliente| ["#{cliente.to_label}", cliente.id]}.sort
      campi_per_select = [['-seleziona-','']] + campi_per_select if aggiungi_cliente_vuoto
      "#{select 'record', :cliente, campi_per_select, :name => input_name, :selected => cliente_selezionato} <span style='color: #999;'>vengono visualizzati solo clienti con rapporti fatturabili</span>"
     else
      #campi_per_select = [['-seleziona-','']]+
      #                   Tipologia.find(:all, :order => :matrice_id).map{|tipologia| ["#{tipologia.matrice.nome}-#{tipologia.nome}", tipologia.id]}
      # ATTENTO ALLA SEGUENTE.... ci vuole TIPOLOGIA_ID
      #select 'record', :tipologia_id, campi_per_select, :name => input_name
#      prove_incluse = ''
#      record.tipologia.prove.each{|prova| prove_incluse += "<#{prova.nome}>"}
#      return "<strong>#{record.tipologia.to_label}</strong><br /><small>Prove: #{h prove_incluse}</small>"
      return "<strong>#{record.cliente.to_label}</strong>"
    end
  end

  def numero_form_column(record, input_name)
    if record.numero.blank?
      #fatture_anno_in_corso = Fattura.find(:all, :order => "numero DESC", :conditions => "numero IS NOT NULL AND data_emissione >= #{DateTime.now.year}-01-01")
      fatture_anno_in_corso = Fattura.find(:all, :order => "numero DESC", :conditions => "numero IS NOT NULL AND anno = #{DateTime.now.year}")
      #ultimo_fattura = Fattura.find(:first, :order => "numero DESC", :conditions => "numero != 0 AND data_richiesta > '#{DateTime.now.year}-01-01'")
      ultima_fattura = fatture_anno_in_corso[0]
      if ultima_fattura.nil?
        # tengo conto del caso in cui non ci siano fatture
        prossimo_numero_libero = 1
        # Non ci sono fatture presenti per l'anno in corso, iniziare dunque con il n. 1
      else
        prossimo_numero_libero = ultima_fattura.numero+1
        # Metto un commento che avverta se qualche numero e' saltato
        numeri_fattura = fatture_anno_in_corso.map{|fattura| fattura.numero}
        numeri_saltati = (1..ultima_fattura.numero).map{|x| x} - numeri_fattura
        unless numeri_saltati.size == 0
          commento_2 = "<strong>ATTENZIONE</strong>: il massimo numero inserito è il #{ultima_fattura.numero.to_s}, ma sono liberi i numeri: #{numeri_saltati.sort.map{|x| "#{x}, "}}<br/>"
        end
      end
      commento_1 = "<dd><span class='description'>(prossimo numero: <strong>#{prossimo_numero_libero}</strong>)</span></dd>"
    end
    if params[:action] == 'new'
      "#{text_field :record, :numero, :name => input_name, :size => 4, :maxlength => 4, :value => prossimo_numero_libero} #{commento_1} <br/><dd><span class='description'>#{commento_2}</span></dd>"
    else
      "#{text_field :record, :numero, :name => input_name, :size => 4, :maxlength => 4, :value => record.numero} #{commento_1} <br/><dd><span class='description'>#{commento_2}</span></dd>"
    end

  end  

  def anno_form_column(record, input_name)
    # attenzione, non puoi usare il seguente visto ke l'anno NON è una data!
    # date_select(:record, :anno, :start_year => 1960, :end_year => 2070, :discard_day => true,  :discard_month => true, :include_blank=> true, :default => { :year => Time.now.year })
    #selected_value = record.anno || Time.now.year
    #select(:record, :anno, (1960..2070).map{|anno| [anno, anno]}, {:include_blank => true, :selected => selected_value, :name => input_name})
    #select(:record, :anno, (1960..2070).map{|anno| [anno, anno]}, {:include_blank => true, :name => input_name})
    select(:record, :anno, (1960..2070).map{|anno| [anno, anno]}, {:include_blank => false, :selected => Time.now.year, :name => input_name})
  end

  def data_pagamento_form_column(record, input_name)
    date_select(:record, :data_pagamento, :include_blank => true, :order => [:day, :month, :year])
  end

  def data_inizio_form_column(record, input_name)
    suggerimento = ""
    unless record.rapporti.empty?
      suggerimento += "Rapporti inclusi: <b>#{record.rapporti.size}</b>"
      # record.variabile_rapporto_items contiene tutti i risultati, e la data di ciascuno (che viene automaticamente aggiornata ad ogni modifica del dato)
      tutte_le_date = record.rapporti.map {|rapporto| rapporto.data_stampa}# +
                      #record.rapporti.map {|rapporto| rapporto.data_esecuzione_prove_fine}
      tutte_le_date.compact!
      tutte_le_date.uniq!
      tutte_le_date.sort!
      unless tutte_le_date.empty?
        data_inferiore = tutte_le_date.first
        data_superiore = tutte_le_date.last
        suggerimento += " (dal <b>#{formatta_data data_inferiore}</b> al <b>#{formatta_data data_superiore}</b>)<br/>"
      end
    end
    cliente_in_memoria = record.cliente 
    cliente_in_memoria = Cliente.find(params[:cliente_id]) if params[:cliente_id]
    unless cliente_in_memoria.nil?
      if cliente_in_memoria.rapporti_fatturabili.empty?
        suggerimento += "<i>Non ci sono rapporti fatturabili da aggiungere</i>"
      else
        tutte_le_date = cliente_in_memoria.rapporti_fatturabili.map {|rapporto| rapporto.data_stampa}
        tutte_le_date.compact!
        tutte_le_date.uniq!
        tutte_le_date.sort!
        unless tutte_le_date.empty?
          data_inferiore = tutte_le_date.first
          data_superiore = tutte_le_date.last
          suggerimento += "Ci sono #{"altri " unless record.rapporti.empty?} <b>#{cliente_in_memoria.rapporti_fatturabili.size}</b> rapporti fatturabili per #{cliente_in_memoria.nome} con data dal <b>#{data_inferiore.strftime('%d-%m-%y')}</b> al <b>#{data_superiore.strftime('%d-%m-%y')}</b>"
        end
      end
    end
    if record.id.nil?
      if data_inferiore
        suggerimento+"<br/>"+"#{date_select(:record, :data_inizio, :default => data_inferiore,  :order => [:day, :month, :year])} "
      else
        suggerimento+"<br/>"+"#{date_select(:record, :data_inizio, :include_blank => true,      :order => [:day, :month, :year])} "
      end
    else
      "<big><b>#{formatta_data record.data_inizio}</b></big>" +"<br/>"+ suggerimento
    end
  end

  def data_fine_form_column(record, input_name)
    cliente_in_memoria = record.cliente
    cliente_in_memoria = Cliente.find(params[:cliente_id]) if params[:cliente_id]
    unless cliente_in_memoria.nil?
     if cliente_in_memoria.rapporti_fatturabili.empty?
#        suggerimento += "<i>non ci sono rapporti fatturabili da aggiungere</i>"
      else
        tutte_le_date = cliente_in_memoria.rapporti_fatturabili.map {|rapporto| rapporto.data_stampa}
        tutte_le_date.compact!
        tutte_le_date.uniq!
        tutte_le_date.sort!
        unless tutte_le_date.empty?
#          data_inferiore = tutte_le_date.first
          data_superiore = tutte_le_date.last
#          suggerimento += "Ci sono #{"altri " unless record.rapporti.empty?} <b>#{cliente_in_memoria.rapporti_fatturabili.size}</b> rapporti fatturabili per #{cliente_in_memoria.nome} con data dal <b>#{data_inferiore.strftime('%d-%m-%y')}</b> al <b>#{data_superiore.strftime('%d-%m-%y')}</b>"
        end
      end
    end
    if record.id.nil?
      if data_superiore
        "#{date_select(:record, :data_fine, :default => data_superiore, :order => [:day, :month, :year])} <br/>"
      else
        "#{date_select(:record, :data_fine, :include_blank => true,     :order => [:day, :month, :year])} <br/>"
      end
    else
      "<big><b>#{formatta_data record.data_fine}</b></big>"
    end
  end

#  def options_for_association_conditions(association)
#    if association.name == :rapporti
#
#      fattura = Fattura.find(params[:id].to_i)
#      rapporti_da_mostrare = fattura.cliente.rapporti.map{|rapporto| rapporto.id}
#      #['rapporti.id = ?', 2]
#      ['rapporti.id IN (?)', rapporti_da_mostrare]
#      #['campione_id IN (?)', campioni_da_mostrare]
#    else
#      super
#    end
#  end

#  def rapporto_id_form_column(record, options)
#      collection_select(record, :rapporto_id, Rapporto.find(:sall), :id, :numero, {}, options)
#  end
#
#  def rapporto_form_column(record, input_name)
#    #debugger
#    # n.b. params[:id] equivale all'id del rapporto
#    #matrice = Tipologia.find_by_id(params[:id]).matrice
#    collection_select(:record, :rapporto_id, Rapporto.find(:all)[0], :id, :nome, {:include_blank => true}, {:name => input_name} )
#  end

  def rapporto_form_column(record, input_name)
    #debugger
    # n.b. params[:id] equivale all'id del rapporto
    #matrice = Rapporto.find_by_id(params[:id]).tipologia.matrice
    # includere solo i rapporti di quel cliente e che non sono inclusi in qualche fattura
    cliente = Fattura.find_by_id(params[:id]).cliente
    # prendo tutti i rapporti COMPLETI del cliente
    rapporti_da_mostrare = cliente.rapporti_completi.clone
    # cancello quelli già inclusi (cioè cancello i rapporti che hanno una fattura ... a meno che non si tratti di quelli di QUESTA fattura)
    rapporti_da_mostrare.delete_if {|rapporto| !rapporto.fattura.nil? && rapporto.fattura.id != params[:id].to_i}
    rapporti_da_mostrare.sort! {|x,y| y.created_at <=> x.created_at }
    #rapporti_da_mostrare.reverse!
    collection_select(:record, :rapporto_id, rapporti_da_mostrare, :id, :label_per_fattura, {:include_blank => true}, {:name => input_name} )

  end

#  def prova_form_column(record, input_name)
#    #debugger
#    # n.b. params[:id] equivale all'id del rapporto
#    matrice = Rapporto.find_by_id(params[:id]).tipologia.matrice
#    collection_select(:record, :prova_id, Prova.find(:all,  :conditions => { :matrice_id => matrice.id}, :order => "nome"), :id, :nome, {:include_blank => true}, {:name => input_name} )
#  end
#
end
