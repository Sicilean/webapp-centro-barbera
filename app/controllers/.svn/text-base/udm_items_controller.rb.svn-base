class UdmItemsController < ApplicationController
  layout 'admin'
  before_filter :require_admin_or_operator

  active_scaffold :udm_item do |config|
    #columns[:nome].description = "nome breve"
    columns = [
                :nome,
                :variabili,
                #:matrici, serve a poco
               ]
    config.columns = 	columns
    config.list.columns = columns
    config.create.columns.exclude :variabili
    config.update.columns.exclude :variabili
    #config.show.columns.exclude :variabili
    #config.columns[:campioni].form_ui = :select
    list.sorting = {:nome => :asc}
  end

#  # GET /udm_items
#  # GET /udm_items.xml
#  def index
#    @udm_items = UdmItem.all
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @udm_items }
#    end
#  end
#
#  # GET /udm_items/1
#  # GET /udm_items/1.xml
#  def show
#    @udm_item = UdmItem.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @udm_item }
#    end
#  end
#
#  # GET /udm_items/new
#  # GET /udm_items/new.xml
#  def new
#    @udm_item = UdmItem.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @udm_item }
#    end
#  end
#
#  # GET /udm_items/1/edit
#  def edit
#    @udm_item = UdmItem.find(params[:id])
#  end
#
#  # POST /udm_items
#  # POST /udm_items.xml
#  def create
#    @udm_item = UdmItem.new(params[:udm_item])
#
#    respond_to do |format|
#      if @udm_item.save
#        flash[:notice] = 'UdmItem was successfully created.'
#        format.html { redirect_to(@udm_item) }
#        format.xml  { render :xml => @udm_item, :status => :created, :location => @udm_item }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @udm_item.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # PUT /udm_items/1
#  # PUT /udm_items/1.xml
#  def update
#    @udm_item = UdmItem.find(params[:id])
#
#    respond_to do |format|
#      if @udm_item.update_attributes(params[:udm_item])
#        flash[:notice] = 'UdmItem was successfully updated.'
#        format.html { redirect_to(@udm_item) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @udm_item.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # DELETE /udm_items/1
#  # DELETE /udm_items/1.xml
#  def destroy
#    @udm_item = UdmItem.find(params[:id])
#    @udm_item.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(udm_items_url) }
#      format.xml  { head :ok }
#    end
#  end
end
