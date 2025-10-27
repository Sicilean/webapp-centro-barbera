# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def formatta_prezzo(prezzo)
    euro, cents = (prezzo*100).divmod(100)
    sprintf('%d.%02d€', euro, cents)
  end

  def formatta_prezzo_senza_euro(prezzo)
    euro, cents = (prezzo*100).divmod(100)
    sprintf('%d.%02d', euro, cents)
  end
  def mostra_parametro(codice)
    parametro = Parametro.first(:conditions => [ "codice = ?", codice.to_s ])
    if parametro.nil? || parametro.valore.blank?
      return h "<Parametro:#{codice}>"
    else
      # Verifica se il valore contiene già HTML
      if parametro.valore.match(/<[^>]+>/)
        # Se contiene HTML, rendilo direttamente safe
        return parametro.valore.html_safe
      else
        # Altrimenti trasforma i newline in <br/>
        return trasforma_acapo_in_br parametro.valore
      end
    end
  end
  def mp(codice)
    return mostra_parametro(codice)
  end
  def nome_form_column(record, input_name)
    text_field :record, :nome, :name => input_name, :size => 19, :maxlength => 20
  end
  def nome_esteso_form_column(record, input_name)
    text_field :record, :nome_esteso, :name => input_name, :size => 60, :maxlength => 70
  end
  def note_form_column(record, input_name)
    text_field :record, :note, :name => input_name, :size => 60, :maxlength => 100
  end
  def prezzo_column(record)
    if current_user.is_admin?
      # vedi Agile pag. 94
      euro, cents = (record.prezzo*100).divmod(100)
      sprintf('%d.%02d€', euro, cents)
      #record.prezzo
    end
  end
  def prezzo_totale_column(record)
    if current_user.is_admin?
      # vedi Agile pag. 94
      euro, cents = (record.prezzo_totale*100).divmod(100)
      sprintf('%d.%02d€', euro, cents)
      #record.prezzo
    end
  end
  def prezzo_form_column(record, input_name)
    if current_user.is_admin?
      euro, cents = (record.prezzo*100).divmod(100)
      text_field :record, :prezzo, :name => input_name, :size => 6, :maxlength => 6, :value => sprintf('%d.%02d', euro, cents)
    end
  end
  def da_mostrare_form_column(record, input_name)
    check_box :record, :da_mostrare, :name => input_name
  end

  def formatta_data(data)
    data.strftime("%d-%m-%Y")
  end
  def trasforma_acapo_in_br(stringa)
    if stringa.nil?
      return ''
    else
      risultato = stringa.gsub(/\n/,'<br/>')
      return risultato.html_safe
    end
  end
end
