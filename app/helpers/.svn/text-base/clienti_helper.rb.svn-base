module ClientiHelper
  def codice_fiscale_form_column(record, input_name)
    # 16 caratteri per il codice fiscale
    text_field :record, :codice_fiscale, :name => input_name, :size => 16, :maxlength => 16
  end
  def partita_iva_form_column(record, input_name)
    # 11 caratteri per il codice fiscale
    text_field :record, :partita_iva, :name => input_name, :size => 11, :maxlength => 11
  end
  def provincia_form_column(record, input_name)
    select :record, :provincia, CLIENTE_PROVINCIA_TYPES, :name => input_name
  end
  def fatt_provincia_form_column(record, input_name)
    select :record, :fatt_provincia, CLIENTE_PROVINCIA_TYPES, :name => input_name
  end
  def email_per_notifiche_form_column(record, input_name)
    text_field :record, :email_per_notifiche, :name => input_name, :size => 60, :maxlength => 120
  end
  def fax_form_column(record, input_name)
    text_field :record, :fax, :name => input_name, :size => 20, :maxlength => 20
  end
  def tel_form_column(record, input_name)
    text_field :record, :tel, :name => input_name, :size => 20, :maxlength => 20
  end
  def cap_form_column(record, input_name)
    text_field :record, :cap, :name => input_name, :size => 5, :maxlength => 5
  end
  def fatt_cap_form_column(record, input_name)
    text_field :record, :fatt_cap, :name => input_name, :size => 5, :maxlength => 5
  end
  def comune_form_column(record, input_name)
    text_field :record, :comune, :name => input_name, :size => 30, :maxlength => 30
  end
  def fatt_comune_form_column(record, input_name)
    text_field :record, :fatt_comune, :name => input_name, :size => 30, :maxlength => 30
  end
  def cellulare_per_sms_form_column(record, input_name)
    text_field :record, :cellulare_per_sms, :name => input_name, :size => 19, :maxlength => 40
  end
  def cellulare_per_sms_2_form_column(record, input_name)
    text_field :record, :cellulare_per_sms_2, :name => input_name, :size => 19, :maxlength => 40
  end
  def rapporti_per_anno_column(record)
    anni = record.rapporti.map{|rapporto| rapporto.campione.anno}.compact.uniq.sort.reverse
    output = ''
    anni.each do |anno|
      output += link_to "#{anno}", 
                    :controller => :rapporti,
                    :cliente_id => record.id,
                    :campione_anno => anno,
                    :page => 1,
                    :sort => 'data_richiesta',
                    :sort_direction => 'DESC'

      output += '<br />'
    end
    return output
  end
  def fatture_per_anno_column(record)
    anni = record.fatture.map{|fattura| fattura.anno}.compact.uniq.sort.reverse
    output = ''
    anni.each do |anno|
      output += link_to "#{anno}",
                    :controller => :fatture,
                    :cliente_id => record.id,
                    :anno => anno,
                    :page => 1,
                    :sort => 'data_emissione',
                    :sort_direction => 'DESC'

      output += '<br />'
    end
    #return output + "#{link_to((image_tag 'active_scaffold/default/add.gif', :border=>0), (url_for :controller=> :clienti, :id => record.id, :action => :nested, :_method => :get, :associations => :fatture), :class => 'nested action fatture', :id => 'as_clienti-fatture-nested-66-link', :position =>'after')}"
    unless record.rapporti_fatturabili.empty?
      output += "#{link_to((image_tag 'active_scaffold/default/add.gif', :border=>0), (url_for :controller=> :fatture, :action => :new, :cliente_id => record.id))}"
    end
    return output
  end
end
