class VariabileRapportoItemsController < ApplicationController

  layout 'admin'
  before_filter :require_admin_or_operator

  active_scaffold :variabile_rapporto_item do |config|
    config.actions = [
                      #:create, # NEW
                      :list,
                      :update,
                      #:subform,
                      #:delete,
                      :show,
                      #:nested,  #
                      :search,
                      ]
    #columns[:nome].description = "nome breve"
    columns = [
                :rapporto,
                :variabile,
                :variabile_tipo,
                :manca?,
                :valore_numero,
                :valore_testo,
                :data,
                :incertezza_di_misura,
                :errore,
               ]
    config.columns = 	columns
    config.list.columns = columns
    # config.create.columns.exclude  :variabile_tipo
    config.update.columns.exclude  :variabile_tipo, :manca?, :errore, :data
#    #config.columns[:campioni].form_ui = :select
#    list.sorting = {:campione_id => :asc}
    config.list.sorting =  { :rapporto => :asc }
    config.theme = :blue
  end

  def da_inserire
    # risultati senza valore del tipo non funzione
  end
#  # GET /variabile_rapporto_items
#  # GET /variabile_rapporto_items.xml
#  def index
#    @variabile_rapporto_items = VariabileRapportoItem.all
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @variabile_rapporto_items }
#    end
#  end
#
#  # GET /variabile_rapporto_items/1
#  # GET /variabile_rapporto_items/1.xml
#  def show
#    @variabile_rapporto_item = VariabileRapportoItem.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @variabile_rapporto_item }
#    end
#  end
#
#  # GET /variabile_rapporto_items/new
#  # GET /variabile_rapporto_items/new.xml
#  def new
#    @variabile_rapporto_item = VariabileRapportoItem.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @variabile_rapporto_item }
#    end
#  end
#
#  # GET /variabile_rapporto_items/1/edit
#  def edit
#    @variabile_rapporto_item = VariabileRapportoItem.find(params[:id])
#  end
#
#  # POST /variabile_rapporto_items
#  # POST /variabile_rapporto_items.xml
#  def create
#    @variabile_rapporto_item = VariabileRapportoItem.new(params[:variabile_rapporto_item])
#
#    respond_to do |format|
#      if @variabile_rapporto_item.save
#        flash[:notice] = 'VariabileRapportoItem was successfully created.'
#        format.html { redirect_to(@variabile_rapporto_item) }
#        format.xml  { render :xml => @variabile_rapporto_item, :status => :created, :location => @variabile_rapporto_item }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @variabile_rapporto_item.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # PUT /variabile_rapporto_items/1
#  # PUT /variabile_rapporto_items/1.xml
#  def update
#    @variabile_rapporto_item = VariabileRapportoItem.find(params[:id])
#
#    respond_to do |format|
#      if @variabile_rapporto_item.update_attributes(params[:variabile_rapporto_item])
#        flash[:notice] = 'VariabileRapportoItem was successfully updated.'
#        format.html { redirect_to(@variabile_rapporto_item) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @variabile_rapporto_item.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # DELETE /variabile_rapporto_items/1
#  # DELETE /variabile_rapporto_items/1.xml
#  def destroy
#    @variabile_rapporto_item = VariabileRapportoItem.find(params[:id])
#    @variabile_rapporto_item.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(variabile_rapporto_items_url) }
#      format.xml  { head :ok }
#    end
#  end
end
