class AutoProvaRapportoItemsController < ApplicationController

  layout 'admin'
  before_filter :require_admin_or_operator

  active_scaffold :auto_prova_rapporto_item do |config|
    #columns[:nome].description = "nome breve"
    columns = [
                :rapporto,
                :prova,
                :prezzo,
               ]
    config.columns = 	columns
    config.list.columns = columns
#    config.create.columns.exclude :prezzo
#    config.update.columns.exclude :prezzo
#    #config.columns[:campioni].form_ui = :select
#    list.sorting = {:campione_id => :asc}
    config.subform.columns.exclude :rapporto, :prova
    config.update.columns.exclude  :rapporto, :prova
    #config.subform.columns.exclude :prova
    #config.subform.layout = :prove_aggiuntive
    #config.columns[:prova].set_link('nested', :parameters => nil)
    config.theme = :blue
  end

#  # GET /auto_prova_rapporto_items
#  # GET /auto_prova_rapporto_items.xml
#  def index
#    @auto_prova_rapporto_items = AutoProvaRapportoItem.all
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @auto_prova_rapporto_items }
#    end
#  end
#
#  # GET /auto_prova_rapporto_items/1
#  # GET /auto_prova_rapporto_items/1.xml
#  def show
#    @auto_prova_rapporto_item = AutoProvaRapportoItem.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @auto_prova_rapporto_item }
#    end
#  end
#
#  # GET /auto_prova_rapporto_items/new
#  # GET /auto_prova_rapporto_items/new.xml
#  def new
#    @auto_prova_rapporto_item = AutoProvaRapportoItem.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @auto_prova_rapporto_item }
#    end
#  end
#
#  # GET /auto_prova_rapporto_items/1/edit
#  def edit
#    @auto_prova_rapporto_item = AutoProvaRapportoItem.find(params[:id])
#  end
#
#  # POST /auto_prova_rapporto_items
#  # POST /auto_prova_rapporto_items.xml
#  def create
#    @auto_prova_rapporto_item = AutoProvaRapportoItem.new(params[:auto_prova_rapporto_item])
#
#    respond_to do |format|
#      if @auto_prova_rapporto_item.save
#        format.html { redirect_to(@auto_prova_rapporto_item, :notice => 'AutoProvaRapportoItem was successfully created.') }
#        format.xml  { render :xml => @auto_prova_rapporto_item, :status => :created, :location => @auto_prova_rapporto_item }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @auto_prova_rapporto_item.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # PUT /auto_prova_rapporto_items/1
#  # PUT /auto_prova_rapporto_items/1.xml
#  def update
#    @auto_prova_rapporto_item = AutoProvaRapportoItem.find(params[:id])
#
#    respond_to do |format|
#      if @auto_prova_rapporto_item.update_attributes(params[:auto_prova_rapporto_item])
#        format.html { redirect_to(@auto_prova_rapporto_item, :notice => 'AutoProvaRapportoItem was successfully updated.') }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @auto_prova_rapporto_item.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # DELETE /auto_prova_rapporto_items/1
#  # DELETE /auto_prova_rapporto_items/1.xml
#  def destroy
#    @auto_prova_rapporto_item = AutoProvaRapportoItem.find(params[:id])
#    @auto_prova_rapporto_item.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(auto_prova_rapporto_items_url) }
#      format.xml  { head :ok }
#    end
#  end
end
