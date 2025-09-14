module VariabiliHelper

  def nome_form_column(record, input_name)
    text_field :record, :nome, :name => input_name, :size => 60, :maxlength => 70
  end
  def forza_zero_column(record)
    if record.forza_zero
      "sì"
    else
      #"no"
    end
  end

#  def matrice_column(record)
#    link_to record.matrice.nome, '#' unless record.matrice.nil?
#  end

  def udm_item_column(record)
    if record.udm_item.nil?
      "--non specificata--"
    else
      link_to record.udm_item.nome, '#' 
    end
  end
  
  def max_column(record)
    "#{record.max}"
  end

  def min_column(record)
    "#{record.min}"
  end

  #
  def forza_zero_form_column(record, input_name)
    check_box :record, :forza_zero, :name => input_name
  end

  def tipo_form_column(record, input_name)
    select :record, :tipo, VARIABILE_TIPO_TYPES, :name => input_name
  end



  def decimali_form_column(record, input_name)
    select :record, :decimali, VARIABILE_DECIMALI_TYPES, :name => input_name
  end

  def matrice_form_column(record, input_name)
    if record.id.nil?
      select :record, :matrice, [['-seleziona-','']]+Matrice.all.map{|matrice| [matrice.nome, matrice.id]}, :name => input_name
    else
      return "<strong>#{record.matrice.nome}</strong>"
    end
  end

  def simbolo_form_column(record, input_name)
    if record.id.nil? || record.viene_utilizzata_in_altre_variabili?
      risultato = "#{text_field :record, :simbolo, :name => input_name, :size => 4, :maxlength => 4}"
      risultato += "(puoi rinominare, visto che non compare in nessuna formula)" unless record.id.nil?
      return risultato
    else
      risultato = ''
      record.variabili_in_cui_viene_utilizzata.each {|x| risultato += "<#{link_to x.simbolo, x}>"}
      return "<strong>#{record.simbolo}</strong> (compare nella formula di: #{risultato}) <br />"  #{variabili_in_cui_viene_utilizzata})"
    end
  end

  def min_form_column(record, input_name)
    text_field :record, :min, :name => input_name, :size => 8, :maxlength => 8
  end
  def max_form_column(record, input_name)
    text_field :record, :max, :name => input_name, :size => 10, :maxlength => 10
  end

  def udm_item_form_column(record, input_name)
    select :record, :udm_item, UdmItem.all.map{|udm_item| [udm_item.nome, udm_item.id]}, :name => input_name, :selected => record.udm_item_id, :include_blank => true
  end

end
