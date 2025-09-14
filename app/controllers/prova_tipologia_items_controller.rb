class ProvaTipologiaItemsController < ApplicationController
  layout 'admin'
  before_filter :require_admin_or_operator
  

  active_scaffold :prova_tipologia_item do |config|
    #columns[:nome].description = "nome breve"
    columns = [
                :prova,
                :tipologia,
                :position,
               ]
    config.columns = 	columns
    config.list.columns = columns  - [:position]
    # ATTENZIONE, le seguenti non le puoi mettere altrimenti perdi l'ordinamento delle prove
    #config.create.columns.exclude :position
    #config.update.columns.exclude :position
    #config.subform.columns.exclude :position

    #config.columns[:campioni].form_ui = :select
    config.columns[:position].label =  ' ' # per nascondere ... necessario!

    list.sorting = {:position => :desc}

  end

#  # GET /prova_tipologia_items
#  # GET /prova_tipologia_items.xml
#  def index
#    @prova_tipologia_items = ProvaTipologiaItem.all
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @prova_tipologia_items }
#    end
#  end
#
#  # GET /prova_tipologia_items/1
#  # GET /prova_tipologia_items/1.xml
#  def show
#    @prova_tipologia_item = ProvaTipologiaItem.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @prova_tipologia_item }
#    end
#  end
#
#  # GET /prova_tipologia_items/new
#  # GET /prova_tipologia_items/new.xml
#  def new
#    @prova_tipologia_item = ProvaTipologiaItem.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @prova_tipologia_item }
#    end
#  end
#
#  # GET /prova_tipologia_items/1/edit
#  def edit
#    @prova_tipologia_item = ProvaTipologiaItem.find(params[:id])
#  end
#
#  # POST /prova_tipologia_items
#  # POST /prova_tipologia_items.xml
#  def create
#    @prova_tipologia_item = ProvaTipologiaItem.new(params[:prova_tipologia_item])
#
#    respond_to do |format|
#      if @prova_tipologia_item.save
#        flash[:notice] = 'ProvaTipologiaItem was successfully created.'
#        format.html { redirect_to(@prova_tipologia_item) }
#        format.xml  { render :xml => @prova_tipologia_item, :status => :created, :location => @prova_tipologia_item }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @prova_tipologia_item.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # PUT /prova_tipologia_items/1
#  # PUT /prova_tipologia_items/1.xml
#  def update
#    @prova_tipologia_item = ProvaTipologiaItem.find(params[:id])
#
#    respond_to do |format|
#      if @prova_tipologia_item.update_attributes(params[:prova_tipologia_item])
#        flash[:notice] = 'ProvaTipologiaItem was successfully updated.'
#        format.html { redirect_to(@prova_tipologia_item) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @prova_tipologia_item.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # DELETE /prova_tipologia_items/1
#  # DELETE /prova_tipologia_items/1.xml
#  def destroy
#    @prova_tipologia_item = ProvaTipologiaItem.find(params[:id])
#    @prova_tipologia_item.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(prova_tipologia_items_url) }
#      format.xml  { head :ok }
#    end
#  end
end
