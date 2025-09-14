module RapportiHelper

#  def data_scadenza_column(record)
#    "#{record.data_scadenza.to_s(:short)}"
#  end
##  def data_richiesta_column(record)
##    "#{record.data_richiesta.to_s(:short)}"
##  end
##  def data_invio_sms_column(record)
##    "#{record.data_invio_sms.to_s(:short)}" unless record.data_invio_sms.nil?
##  end
#  def data_invio_email_column(record)
#    "#{record.data_invio_email.to_s(:short)}" unless record.data_invio_sms.nil?
#  end
#
#  def numero_column(record)
#    if record.anno.nil?
#      record.numero
#    else
#      "#{record.anno}-#{record.numero}"
#    end
#  end

  def status_column(record)
    # questo inserito solo per rimpicciolire il carattere
    "<small>#{record.status}</small>"
  end

  def fattura_link_column(record)
    if record.fattura
      "#{link_to record.fattura.to_label, :controller => :fatture, :fattura_id => record.fattura.id}"
    else
      " "
    end
  end

  def numero_form_column(record, input_name)
    if record.numero.blank?
      rapporti_anno_in_corso = Rapporto.find(:all, :order => "numero DESC", :conditions => "numero IS NOT NULL AND anno = #{DateTime.now.year}")
      #ultimo_rapporto = Rapporto.find(:first, :order => "numero DESC", :conditions => "numero != 0 AND data_richiesta > '#{DateTime.now.year}-01-01'")
      ultimo_rapporto = rapporti_anno_in_corso[0]
      if ultimo_rapporto.nil?
        # tengo conto del caso in cui non ci siano rapporti
        prossimo_numero_libero = 1
        # Non ci sono rapporti presenti per l'anno in corso, iniziare dunque con il n. 1
      else
        prossimo_numero_libero = ultimo_rapporto.numero+1
        # Metto un commento che avverta se qualche numero e' saltato
        numeri_rapporto = rapporti_anno_in_corso.map{|rapporto| rapporto.numero}
        numeri_saltati = (1..ultimo_rapporto.numero).map{|x| x} - numeri_rapporto
        unless numeri_saltati.size == 0
          commento_2 = "<strong>ATTENZIONE</strong>: il massimo Rdp inserito è il #{ultimo_rapporto.numero.to_s}, ma sono liberi i numeri: #{numeri_saltati.sort.map{|x| "#{x}, "}}<br/>"
        end
      end
      commento_1 = "(prossimo Rdp: <strong>#{prossimo_numero_libero}</strong>)"
    end
    "#{text_field :record, :numero, :name => input_name, :size => 4, :maxlength => 4} #{commento_1} <dd><span class='description'>#{commento_2}</span></dd>"
  end

  def anno_form_column(record, input_name)
    # attenzione, non puoi usare il seguente visto ke l'anno NON è una data!
    # date_select(:record, :anno, :start_year => 2010, :end_year => 2019, :discard_day => true,  :discard_month => true, :include_blank=> true, :default => { :year => Time.now.year })
    #selected_value = record.anno || Time.now.year
    #select(:record, :anno, (2010..2019).map{|anno| [anno, anno]}, {:include_blank => true, :selected => selected_value, :name => input_name})
    select(:record, :anno, (2010..2019).map{|anno| [anno, anno]}, {:include_blank => true, :name => input_name})
  end

#  def tipologia_form_column(record, input_name)
#      campi_per_select = [['-seleziona-','']]+[['-sele32ziona-',32]]+Tipologia.find(:all, :order => :matrice_id).map{|tipologia| ["#{tipologia.matrice.nome}-#{tipologia.nome}", tipologia.id]}
#      select :record, :tipologia, campi_per_select, :name => input_name
#  end
  def tipologia_form_column(record, input_name)
     if record.id.nil?
      campi_per_select = [['-seleziona-','']]+
                         Tipologia.all.map{|tipologia| 
                           matrice_nome = tipologia.matrice.nil? ? 'Senza Matrice' : tipologia.matrice.nome
                           ["#{matrice_nome} - #{tipologia.to_label}", tipologia.id]
                         }.sort
      select 'record', :tipologia, campi_per_select, :name => input_name
     else
      #campi_per_select = [['-seleziona-','']]+
      #                   Tipologia.find(:all, :order => :matrice_id).map{|tipologia| ["#{tipologia.matrice.nome}-#{tipologia.nome}", tipologia.id]}
      # ATTENTO ALLA SEGUENTE.... ci vuole TIPOLOGIA_ID
      #select 'record', :tipologia_id, campi_per_select, :name => input_name
#      prove_incluse = ''
#      record.tipologia.prove.each{|prova| prove_incluse += "<#{prova.nome}>"}
#      return "<strong>#{record.tipologia.to_label}</strong><br /><small>Prove: #{h prove_incluse}</small>"
      return "<strong>#{record.tipologia.to_label}</strong> #{' (forfeit)' if record.tipologia.forfeit}"
    end
  end
  def campione_form_column(record, input_name)
     if record.id.nil?
      # TODO ordina i campioni tenendo conto dell'anno diverso
      #record.campione = Campione.find(params[:campione_id].to_i)
      campi_per_select = [['-seleziona-','']]+
                         Campione.find(:all, :order => 'numero DESC').map{|campione| ["#{campione.to_label}", campione.id]}
      select :record, :campione, campi_per_select, :name => input_name, :selected => params[:campione_id].to_i
     else
      return "<strong>#{record.campione.to_label}</strong>"
    end
  end

  def duplica_rapporto_link_column(record)
    if record.status == 'completo'
      link_to 'D', :controller => :admin, :action => :duplica_rapporto, :id => record.id
    end
  end
  
  def dati_rapporto_link_column(record)
    if record.prove_totali.size == 0
      "<small>Senza prove:</small> #{link_to 'Modifica', :controller => 'rapporti', :action => 'edit', :id => record.id}"
    else
      link_to 'Input Dati', :controller => :admin, :action => :dati_rapporto, :id => record.id
    end
  end
  def stampa_rapporto_link_column(record)
    if record.completo?
      if record.numero.blank?
        "<small>manca n.Rdp per stampare: </small> #{link_to 'Modifica', :controller => 'rapporti', :action => 'edit', :id => record.id}"
      else
        if record.pdf_esiste?
        "#{link_to 'Rdp_'+record.numero.to_s,                      :controller => :rapporti, :action => :mostra_pdf, :id => record.id}<br />"+
        "#{link_to((image_tag 'pdf_icon.gif', :border => 0), :controller => :rapporti, :action => :mostra_pdf, :id => record.id)}"
        else
          "Rdp_#{record.numero}"
        end
      end
    else
      "Rdp_#{record.numero}" unless record.numero.blank?
    end
  end
  def stampa_dati_link_column(record)
    if record.completo?
        link_anteprima = '/rapporti/anteprima_risultati?'
        link_anteprima += "rapporty_array[]=#{record.id}&"
        link_anteprima_pdf = link_anteprima + 'format=pdf'
        "#{link_to 'Anteprima', link_anteprima_pdf}<br />"+
        "#{link_to((image_tag 'pdf_icon.gif', :border => 0), link_anteprima_pdf)}"
    end
  end
  def note_form_column(record, input_name)
    text_area :record, :note, :name => input_name, :cols => 80, :rows => 2
  end
  def numero_supplemento_form_column(record, input_name)
    text_field :record, :numero_supplemento, :name => input_name, :size => 2, :maxlength => 2
  end
  # SUBFORM
  # vedi http://wiki.github.com/activescaffold/active_scaffold/subform-form-overrides
#  def prova_form_column(record, input_name)
#    collection_select(:record, :prova_id, Prova.all, :id, :nome, {:include_blank => true}, {:name => input_name} )
#  end
  def prova_form_column(record, input_name)
    # NB record è della classe prova_rapporto_items!!!
    # ma entrando qui non è ancora caricato... quindi non posso chiedere prova_rapporto_item.rapporto
    rapporto = Rapporto.find_by_id(params[:id])
    if rapporto.tipologia.forfeit
      return "<span style='color: #999;'>non aggiungibili</span>"
    else
      #debugger
      # n.b. params[:id] equivale all'id del rapporto
      matrice = Rapporto.find_by_id(params[:id]).tipologia.matrice
      collection_select(:record, :prova_id, Prova.find(:all,  :conditions => { :matrice_id => matrice.id}, :order => "nome"), :id, :nome, {:include_blank => true}, {:name => input_name} )
    end
  end
  def position_form_column(record, input_name)
   #text_field :record, :position, :name => input_name, :size => 15, :maxlength => 20, :value => record.position || ((Time.now.to_f*1000).to_i-("Thu Jan 1 00:00:00 +0200 2010".to_time.to_f*1000).to_i)
   hidden_field :record, :position, :name => input_name, :value => record.position || ((Time.now.to_f*1000).to_i-("Thu Jan 1 00:00:00 +0200 2010".to_time.to_f*1000).to_i)
  end


  def data_richiesta_form_column(record, input_name)
    data_di_default = Time.now
    unless params[:campione_id].nil?
      campione = Campione.find_by_id(params[:campione_id])
      data_di_default = campione.data unless campione.nil?
    end
    date_select(:record, :data_richiesta, :order => [:day, :month, :year], :default => data_di_default )
  end

  def data_scadenza_form_column(record, input_name)
#    data_di_default = Time.now
#    if params[:campione_id].nil?
#      campione = Campione.find_by_id(params[:campione_id])
#      data_di_default = campione.data unless campione.nil?
#    end
#    # scadenza di default dopo TOT giorni
#    date_select(:record, :data_scadenza, :order => [:day, :month, :year], :default => data_di_default+3*(60*60*24))
    datetime_select(:record, :data_scadenza, :include_blank => true, :order => [:day, :month, :year, :hour, :minute])
  end

  def data_esecuzione_prove_inizio_form_column(record, input_name)
    suggerimento = ""
    unless record.variabile_rapporto_items.empty?
      # record.variabile_rapporto_items contiene tutti i risultati, e la data di ciascuno (che viene automaticamente aggiornata ad ogni modifica del dato)
      tutte_le_date = record.variabile_rapporto_items.map {|variabile_rapporto_item| variabile_rapporto_item.data}
      tutte_le_date.compact!
      tutte_le_date.uniq!
      tutte_le_date.sort!
      unless tutte_le_date.empty?
        data_inferiore = tutte_le_date.first
        data_superiore = tutte_le_date.last
        if data_inferiore == data_superiore
          suggerimento = "N.b. I dati delle prove attuali sono stati inseriti il giorno #{data_inferiore.strftime('%d-%m-%y')}"
        else
          suggerimento = "N.b. I dati delle prove attuali sono stati inseriti dal #{data_inferiore.strftime('%d-%m-%y')} al #{data_superiore.strftime('%d-%m-%y')}"
        end
      end
    end
    "#{date_select(:record, :data_esecuzione_prove_inizio, :include_blank => true, :order => [:day, :month, :year])} "+suggerimento
  end

  def data_esecuzione_prove_fine_form_column(record, input_name)
    date_select(:record, :data_esecuzione_prove_fine,   :include_blank => true, :order => [:day, :month, :year])
  end
  def data_stampa_form_column(record, input_name)
    date_select(:record, :data_stampa, :include_blank => true, :order => [:day, :month, :year])
  end
  def data_invio_sms_form_column(record, input_name)
    date_select(:record, :data_invio_sms, :include_blank => true, :order => [:day, :month, :year])
  end
  def data_invio_email_form_column(record, input_name)
    date_select(:record, :data_invio_email, :include_blank => true, :order => [:day, :month, :year])
  end

  def pie_pagina_form_column(record, input_name)
    text_area :record, :pie_pagina, :name => input_name, :cols => 80, :rows => 4
  end

  def data_invio_sms_column(record)
    if record.status == 'completo'
      if record.data_invio_sms.nil?
        link_to 'Invia', invia_sms_url(:id => record.id)
      else
        "#{record.data_invio_sms.strftime("%d-%m-%y")}<br />#{link_to 'Invia', invia_sms_url(:id => record.id)}"
      end
    end
  end
  
  def data_invio_email_column(record)
    if record.status == 'completo'
      if record.data_invio_email.nil?
        link_to 'Invia', invia_email_url(:id => record.id)
      else
        "#{record.data_invio_email.strftime("%d-%m-%y")}<br />#{link_to 'Invia', invia_email_url(:id => record.id)}"
      end
    end
  end
end
