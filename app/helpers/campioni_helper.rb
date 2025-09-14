module CampioniHelper
  # FORM
  def etichetta_form_column(record, input_name)
    text_area :record, :etichetta, :name => input_name, :cols => 80, :rows => 6
  end
#  def numero_form_column(record, input_name)
#    if record.numero.blank?
#      ultimo_campione = Campione.find(:first, :order => "numero DESC", :conditions => "data > '#{DateTime.now.year}-01-01'")
#      if ultimo_campione.nil?
#        # tengo conto del caso in cui non ci siano campioni
#        numero_max = 1
#      else
#        numero_max = ultimo_campione.numero+1
#      end
#      text_field :record, :numero, :name => input_name, :size => 4, :maxlength => 4, :value => numero_max
#    else
#      text_field :record, :numero, :name => input_name, :size => 4, :maxlength => 4
#    end
#  end

  def numero_form_column(record, input_name)
    if record.numero.blank?
      campioni_anno_in_corso = Campione.find(:all, :order => "numero DESC", :conditions => "numero IS NOT NULL AND anno = #{DateTime.now.year}")
      ultimo_campione = campioni_anno_in_corso[0]
      if ultimo_campione.nil?
        # tengo conto del caso in cui non ci siano campioni
        prossimo_numero_libero = 1
        # Non ci sono campioni presenti per l'anno in corso, iniziare dunque con il n. 1
      else
        prossimo_numero_libero = ultimo_campione.numero+1
        # Metto un commento che avverta se qualche numero e' saltato
        numeri_campione = campioni_anno_in_corso.map{|campione| campione.numero}
        numeri_saltati = (1..ultimo_campione.numero).map{|x| x} - numeri_campione
        unless numeri_saltati.size == 0
          commento_2 = "<strong>ATTENZIONE</strong>: il massimo RC inserito è il #{ultimo_campione.numero.to_s}, ma sono liberi i numeri: #{numeri_saltati.sort.map{|x| "#{x}, "}}<br/>"
        end
      end
      commento_1 = "<span class='description'>(prossimo RC: <strong>#{prossimo_numero_libero}</strong>)</span>"
    end
    if params[:action] == 'new'
      "#{text_field :record, :numero, :name => input_name, :size => 4, :maxlength => 4, :value => prossimo_numero_libero} #{commento_1} <dd><span class='description'>#{commento_2}</span></dd>"
    else
      "#{text_field :record, :numero, :name => input_name, :size => 4, :maxlength => 4, :value => record.numero} #{commento_1} <dd><span class='description'>#{commento_2}</span></dd>"
    end
  end

  def anno_form_column(record, input_name)
    # attenzione, non puoi usare il seguente visto ke l'anno NON è una data!
    # date_select(:record, :anno, :start_year => 2010, :end_year => 2019, :discard_day => true,  :discard_month => true, :include_blank=> true, :default => { :year => Time.now.year })
    selected_value = record.anno || Time.now.year
    select(:record, :anno, (2009..2019).map{|anno| [anno, anno]}, {:include_blank => false, :selected => selected_value, :name => input_name})
  end

  def nuovo_rapporto_link_column(record)
    if record.rapporti.empty?
      link_to 'Crea il Rapporto',  :controller => :rapporti, :action => :new, :campione_id => record.id
    else
      link_to 'Crea un nuovo Rapporto', :controller => :rapporti, :action => :new, :campione_id => record.id
    end
  end

  def duplica_campione_link_column(record)
      link_to 'D', :controller => :admin, :action => :duplica_campione, :id => record.id
  end

#  def data_column(record)
#    "#{record.data}"
#  end
  def provincia_form_column(record, input_name)
    select :record, :provincia, CLIENTE_PROVINCIA_TYPES, :name => input_name
  end
  def note_form_column(record, input_name)
    text_area :record, :note, :name => input_name, :cols => 80, :rows => 6
  end
  # suolo
  def ettari_form_column(record, input_name)
    text_field :record, :ettari, :name => input_name, :size => 8, :maxlength => 10
  end
  def superficie_di_prelievo_form_column(record, input_name)
    text_field :record, :superficie_di_prelievo, :name => input_name, :size => 8, :maxlength => 10
  end
  def profondita_di_prelievo_form_column(record, input_name)
    text_field :record, :profondita_di_prelievo, :name => input_name, :size => 8, :maxlength => 10
  end



  def campionamento_form_column(record, input_name)
    text_field :record, :campionamento, :name => input_name, :size => 82
  end





end
