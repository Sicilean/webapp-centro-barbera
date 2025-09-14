module ProveHelper

#  def variabili_column(record)
#    link_to record.variabili.first(5).collect{|variabile| h(variabile.nome)}.join(' , '), :controller => 'variabili'
#    #link_to(h(record.nome), :action => :show, :controller => 'metodi', :id => record.id)
#  end

#  def decimali_form_column(record, input_name)
#    select :record, :decimali, VARIABILE_DECIMALI_TYPES, :name => input_name
#  end

#  def matrice_id_form_column(record, input_name)
#    #select :record, :matrice, [['-seleziona-','']]+Matrice.all.map {|x| [x.nome, x.id.to_s] }, :name => input_name
#    #select :record, :matrice, (Matrice.all.map {|x| [x.nome, x.id] }), :name => input_name
#    # vedi http://api.rubyonrails.org/classes/ActionView/Helpers/FormOptionsHelper.html#M001627
#    #select :record, :matrice_id, Matrice.all.collect {|p| [ p.nome, p.id ] }, { :include_blank => true }
#    select :record, :matrice_id, [['-seleziona-','']]+Matrice.all.map {|x| [x.nome, x.id] }, :name => input_name
#  end


  def matrice_form_column(record, input_name)
    if record.id.nil?
      select :record, :matrice, [['-seleziona-','']]+Matrice.all.map{|matrice| [matrice.nome, matrice.id]}, :name => input_name
    else
      return "<strong>#{record.matrice.nome}</strong>"
    end
  end

  def subappalto_column(record)
    record.subappalto ? 'Sì' : 'No'
  end

  def subappalto_form_column(record, input_name)
    check_box :record, :subappalto, :name => input_name
  end


# la seguente è trucchetto per disabilitare link 
#  def matrice_column(record)
#    link_to record.matrice.nome, '#' unless record.matrice.nil?
#  end

  # la seguente aggiunta non solo per nascondere variabili che non interessano, ma anche e soprattutto
  # perche levandola (e lasciando il form generato da activescaffold) per qualche motivo tal form mi va a
  # tentare di modificare la variabile (anche se non ha senso): ora..visto ke sulla variabile c'è un controllo
  # che mi blocca la modifica se qeusta è usata, implica che non posso aggiungere variabile alle prove
  def variabile_form_column(record, input_name)
    #debugger
    # n.b. params[:id] equivale all'id della prova
    matrice = Prova.find_by_id(params[:id]).matrice
    collection_select(:record, :variabile_id, Variabile.find(:all,  :conditions => { :matrice_id => matrice.id}, :order => "nome"), :id, :nome, {:include_blank => true}, {:name => input_name} )
  end

end
