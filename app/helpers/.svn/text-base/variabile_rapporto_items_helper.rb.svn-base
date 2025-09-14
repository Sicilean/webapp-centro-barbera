module VariabileRapportoItemsHelper

  def valore_numero_column(record)
    number_with_precision(record.valore_numero, :precision => record.variabile.decimali)
  end
  def valore_numero_form_column(record, input_name)
    if record.variabile.tipo == 'input-valore'
      text_field :record, :valore_numero, :name => input_name, :size => 10, :maxlength => 10,  :value => number_with_precision(record.valore_numero, :precision => record.variabile.decimali)
    else
      "-"
    end
  end

  def valore_testo_form_column(record, input_name)
    if record.variabile.tipo == 'input-testo'
      text_field :record, :valore_testo, :name => input_name, :size => 30, :maxlength => 30
    else
      "-"
    end
  end

  def manca_column(record)
    record.manca? ? 'Sì' : 'No'
  end

  def rapporto_form_column(record, input_name)
    "#{record.rapporto.to_label}"
  end
  def variabile_form_column(record, input_name)
    "#{record.variabile.to_label}"
  end

end
