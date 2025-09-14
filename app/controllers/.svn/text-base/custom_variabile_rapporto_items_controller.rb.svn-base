class CustomVariabileRapportoItemsController < ApplicationController

  layout 'admin'
  before_filter :require_admin_or_operator


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
  def update
    @variabile_rapporto_item = VariabileRapportoItem.find(params[:id])
    if @variabile_rapporto_item.update_attributes(params[:variabile_rapporto_item])
      flash[:notice] = 'Dato Aggiornato, e rapporto ricalcolato'
      # TODO nella seguente esegui il ricalcolo solo quando necessario
      @variabile_rapporto_item.rapporto.calcola
      redirect_to :controller => :admin, :action => :dati_rapporto, :id => @variabile_rapporto_item.rapporto.id
    else
      flash[:notice] = 'Errore!'
      redirect_to :controller => :admin, :action => :dati_rapporto, :id => @variabile_rapporto_item.rapporto.id
    end

  end
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

