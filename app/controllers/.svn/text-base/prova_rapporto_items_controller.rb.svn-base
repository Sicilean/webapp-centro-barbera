class ProvaRapportoItemsController < ApplicationController

  layout 'admin'
  before_filter :require_admin_or_operator

  active_scaffold :prova_rapporto_item do |config|
    #columns[:nome].description = "nome breve"
    columns = [ 
                :rapporto,
                :prova,
                :prezzo,
                :position,
               ]
    config.columns = 	columns
    config.list.columns = columns
#    config.create.columns.exclude :prezzo
#    config.update.columns.exclude :prezzo
#    #config.columns[:campioni].form_ui = :select
#    list.sorting = {:campione_id => :asc}
    config.columns[:position].label = ' ' # per nascondere ... necessario!
    config.subform.columns.exclude :prezzo
    config.update.columns.exclude  :prezzo
    list.sorting = {:position => :asc}
    #config.subform.columns.exclude :prova
    #config.subform.layout = :prove_aggiuntive
    config.columns[:prova].set_link('nested', :parameters => nil)
    config.theme = :blue
  end

#  # GET /prova_rapporto_items
#  # GET /prova_rapporto_items.xml
#  def index
#    @prova_rapporto_items = ProvaRapportoItem.all
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @prova_rapporto_items }
#    end
#  end
#
#  # GET /prova_rapporto_items/1
#  # GET /prova_rapporto_items/1.xml
#  def show
#    @prova_rapporto_item = ProvaRapportoItem.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @prova_rapporto_item }
#    end
#  end
#
#  # GET /prova_rapporto_items/new
#  # GET /prova_rapporto_items/new.xml
#  def new
#    @prova_rapporto_item = ProvaRapportoItem.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @prova_rapporto_item }
#    end
#  end
#
#  # GET /prova_rapporto_items/1/edit
#  def edit
#    @prova_rapporto_item = ProvaRapportoItem.find(params[:id])
#  end
#
#  # POST /prova_rapporto_items
#  # POST /prova_rapporto_items.xml
#  def create
#    @prova_rapporto_item = ProvaRapportoItem.new(params[:prova_rapporto_item])
#
#    respond_to do |format|
#      if @prova_rapporto_item.save
#        flash[:notice] = 'ProvaRapportoItem was successfully created.'
#        format.html { redirect_to(@prova_rapporto_item) }
#        format.xml  { render :xml => @prova_rapporto_item, :status => :created, :location => @prova_rapporto_item }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @prova_rapporto_item.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # PUT /prova_rapporto_items/1
#  # PUT /prova_rapporto_items/1.xml
#  def update
#    @prova_rapporto_item = ProvaRapportoItem.find(params[:id])
#
#    respond_to do |format|
#      if @prova_rapporto_item.update_attributes(params[:prova_rapporto_item])
#        flash[:notice] = 'ProvaRapportoItem was successfully updated.'
#        format.html { redirect_to(@prova_rapporto_item) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @prova_rapporto_item.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # DELETE /prova_rapporto_items/1
#  # DELETE /prova_rapporto_items/1.xml
#  def destroy
#    @prova_rapporto_item = ProvaRapportoItem.find(params[:id])
#    @prova_rapporto_item.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(prova_rapporto_items_url) }
#      format.xml  { head :ok }
#    end
#  end
end
