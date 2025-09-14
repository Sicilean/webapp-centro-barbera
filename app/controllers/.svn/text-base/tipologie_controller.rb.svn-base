class TipologieController < ApplicationController
  layout 'admin'
  before_filter :require_admin_or_operator
  

  active_scaffold :tipologia do |config|
    columns[:prezzo].description = "Euro"
    columns[:forfeit].description = "spuntare per Tipologie Rdp a <b>prezzo unico</b>, poi inserire il prezzo"
    columns[:pie_pagina].description = "il testo che verrà stampato a piè pagina sul rapporto di prova (HTML ammesso)"
    columns[:note].description = "note interne (non visibili ai clienti)"

    columns = [
                :nome,
                :nome_esteso,
                :matrice,
                :forfeit,
                :prezzo,
                :sinal,
                :note,
                :pie_pagina,
                #:prove,
                :prova_tipologia_items,
                #:campioni,
                :rapporti,
               ]
    config.columns = 	columns
    # la seguente mi renderebbe nulli i link agli elementi has_many
    #config.actions.exclude :nested
    config.list.columns = columns - [:pie_pagina]
    config.columns[:prova_tipologia_items].label = "Prove da includere"
    config.columns[:rapporti].label = "Rapporti con questa tipologia"
    config.columns[:pie_pagina].label = "Pié pagina"
    config.columns[:note].label = "Note interne"
    config.create.columns.exclude :prova_tipologia_items, :rapporti # necessario in quando non ho tipologia_id
    config.create.columns.exclude :prove
    config.create.columns.exclude :campioni, :prove
    config.update.columns.exclude :campioni, :prove, :rapporti
    config.columns[:matrice].form_ui = :select

    # la seguente fa in modo che 'matrice' punti a show (e non ad edit)
    #config.columns[:matrice].set_link('nested', :parameters => {:associations => :matrice})
    # la seguente mi genera link a vuoto
     config.columns[:matrice].set_link('nested', :parameters => nil)

    config.subform.columns.exclude :matrice, :forfeit, :sinal

    list.per_page = 1000
    #config.columns[:campioni].form_ui = :select
    list.sorting = [{:matrice_id => :asc}, {:nome => :asc}]
  end

#  # GET /tipologie
#  # GET /tipologie.xml
#  def index
#    @tipologie = Tipologia.all
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @tipologie }
#    end
#  end
#
#  # GET /tipologie/1
#  # GET /tipologie/1.xml
#  def show
#    @tipologia = Tipologia.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @tipologia }
#    end
#  end
#
#  # GET /tipologie/new
#  # GET /tipologie/new.xml
#  def new
#    @tipologia = Tipologia.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @tipologia }
#    end
#  end
#
#  # GET /tipologie/1/edit
#  def edit
#    @tipologia = Tipologia.find(params[:id])
#  end
#
#  # POST /tipologie
#  # POST /tipologie.xml
#  def create
#    @tipologia = Tipologia.new(params[:tipologia])
#
#    respond_to do |format|
#      if @tipologia.save
#        flash[:notice] = 'Tipologia was successfully created.'
#        format.html { redirect_to(@tipologia) }
#        format.xml  { render :xml => @tipologia, :status => :created, :location => @tipologia }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @tipologia.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # PUT /tipologie/1
#  # PUT /tipologie/1.xml
#  def update
#    @tipologia = Tipologia.find(params[:id])
#
#    respond_to do |format|
#      if @tipologia.update_attributes(params[:tipologia])
#        flash[:notice] = 'Tipologia was successfully updated.'
#        format.html { redirect_to(@tipologia) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @tipologia.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # DELETE /tipologie/1
#  # DELETE /tipologie/1.xml
#  def destroy
#    @tipologia = Tipologia.find(params[:id])
#    @tipologia.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(tipologie_url) }
#      format.xml  { head :ok }
#    end
#  end
end
