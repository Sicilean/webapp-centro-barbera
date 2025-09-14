module ParametriHelper
  def codice_form_column(record, input_name)
    text_field :record, :codice, :name => input_name, :size => 45, :maxlength => 45
  end
  def note_form_column(record, input_name)
    text_field :record, :note, :name => input_name, :size => 60, :maxlength => 100
  end
  def valore_form_column(record, input_name)
    text_area :record, :valore, :name => input_name, :rows => 3, :cols => 60
  end
end
