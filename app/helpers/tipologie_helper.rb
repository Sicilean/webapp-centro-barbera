module TipologieHelper

  def forfeit_column(record)
    record.forfeit ? 'Sì' : 'No'
  end

  def forfeit_form_column(record, input_name)
      check_box :record, :forfeit, :name => input_name
  end

  def sinal_column(record)
    record.sinal ? 'Sì' : 'No'
  end

  def sinal_form_column(record, input_name)
    check_box :record, :sinal, :name => input_name
  end

  def matrice_form_column(record, input_name)
    if record.id.nil?
      select :record, :matrice, [['-seleziona-','']]+Matrice.all.map{|matrice| [matrice.nome, matrice.id]}, :name => input_name
    else
      return "<strong>#{record.matrice.nome}</strong>"
    end
  end

  def pie_pagina_form_column(record, input_name)
    text_area :record, :pie_pagina, :name => input_name, :cols => 80, :rows => 4
  end

  def prova_form_column(record, input_name)
    #debugger
    # n.b. params[:id] equivale all'id del rapporto
    matrice = Tipologia.find_by_id(params[:id]).matrice
    collection_select(:record, :prova_id, Prova.find(:all,  :conditions => { :matrice_id => matrice.id}, :order => "nome"), :id, :nome, {:include_blank => true}, {:name => input_name} )
  end

  def position_form_column(record, input_name)
   #text_field :record, :position, :name => input_name, :size => 15, :maxlength => 20, :value => record.position || ((Time.now.to_f*1000).to_i-("Thu Jan 1 00:00:00 +0200 2010".to_time.to_f*1000).to_i)
   hidden_field :record, :position, :name => input_name, :value => record.position || ((Time.now.to_f*1000).to_i-("Thu Jan 1 00:00:00 +0200 2010".to_time.to_f*1000).to_i)
  end

end
