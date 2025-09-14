class ProvaVariabileItemsController < ApplicationController
  layout 'admin'
  before_filter :require_admin_or_operator
  

  active_scaffold :prova_variabile_item do |config|
    #columns[:nome].description = "nome breve"
    columns = [
                :prova,
                :variabile,
                #:da_mostrare,
               ]
    config.columns = 	columns
    config.list.columns = columns
    #config.create.columns.exclude :campioni
    #config.update.columns.exclude :campioni
    list.sorting = {:prova_id => :asc}
  end

#  # GET /prova_variabile_items
#  # GET /prova_variabile_items.xml
#  def index
#    @prova_variabile_items = ProvaVariabileItem.all
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @prova_variabile_items }
#    end
#  end
#
#  # GET /prova_variabile_items/1
#  # GET /prova_variabile_items/1.xml
#  def show
#    @prova_variabile_item = ProvaVariabileItem.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @prova_variabile_item }
#    end
#  end
#
#  # GET /prova_variabile_items/new
#  # GET /prova_variabile_items/new.xml
#  def new
#    @prova_variabile_item = ProvaVariabileItem.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @prova_variabile_item }
#    end
#  end
#
#  # GET /prova_variabile_items/1/edit
#  def edit
#    @prova_variabile_item = ProvaVariabileItem.find(params[:id])
#  end
#
#  # POST /prova_variabile_items
#  # POST /prova_variabile_items.xml
#  def create
#    @prova_variabile_item = ProvaVariabileItem.new(params[:prova_variabile_item])
#
#    respond_to do |format|
#      if @prova_variabile_item.save
#        flash[:notice] = 'ProvaVariabileItem was successfully created.'
#        format.html { redirect_to(@prova_variabile_item) }
#        format.xml  { render :xml => @prova_variabile_item, :status => :created, :location => @prova_variabile_item }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @prova_variabile_item.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # PUT /prova_variabile_items/1
#  # PUT /prova_variabile_items/1.xml
#  def update
#    @prova_variabile_item = ProvaVariabileItem.find(params[:id])
#
#    respond_to do |format|
#      if @prova_variabile_item.update_attributes(params[:prova_variabile_item])
#        flash[:notice] = 'ProvaVariabileItem was successfully updated.'
#        format.html { redirect_to(@prova_variabile_item) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @prova_variabile_item.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # DELETE /prova_variabile_items/1
#  # DELETE /prova_variabile_items/1.xml
#  def destroy
#    @prova_variabile_item = ProvaVariabileItem.find(params[:id])
#    @prova_variabile_item.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(prova_variabile_items_url) }
#      format.xml  { head :ok }
#    end
#  end
end
