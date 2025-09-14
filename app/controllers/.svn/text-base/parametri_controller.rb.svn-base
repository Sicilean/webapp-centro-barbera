class ParametriController < ApplicationController
  layout 'admin'
  before_filter :require_admin_or_operator
  
  active_scaffold :parametro do |config|
    #columns[:nome].description = "nome breve"
    columns = [
                :codice,
                :nome,
                :note,
                :valore,
               ]
    config.columns = 	columns
    config.list.columns = columns
    #config.create.columns.exclude :campioni
    #config.update.columns.exclude :campioni
    #config.columns[:campioni].form_ui = :select
    list.sorting = {:codice => :asc}
  end

#  # GET /parametri
#  # GET /parametri.xml
#  def index
#    @parametri = Parametro.all
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @parametri }
#    end
#  end
#
#  # GET /parametri/1
#  # GET /parametri/1.xml
#  def show
#    @parametro = Parametro.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @parametro }
#    end
#  end
#
#  # GET /parametri/new
#  # GET /parametri/new.xml
#  def new
#    @parametro = Parametro.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @parametro }
#    end
#  end
#
#  # GET /parametri/1/edit
#  def edit
#    @parametro = Parametro.find(params[:id])
#  end
#
#  # POST /parametri
#  # POST /parametri.xml
#  def create
#    @parametro = Parametro.new(params[:parametro])
#
#    respond_to do |format|
#      if @parametro.save
#        flash[:notice] = 'Parametro was successfully created.'
#        format.html { redirect_to(@parametro) }
#        format.xml  { render :xml => @parametro, :status => :created, :location => @parametro }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @parametro.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # PUT /parametri/1
#  # PUT /parametri/1.xml
#  def update
#    @parametro = Parametro.find(params[:id])
#
#    respond_to do |format|
#      if @parametro.update_attributes(params[:parametro])
#        flash[:notice] = 'Parametro was successfully updated.'
#        format.html { redirect_to(@parametro) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @parametro.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # DELETE /parametri/1
#  # DELETE /parametri/1.xml
#  def destroy
#    @parametro = Parametro.find(params[:id])
#    @parametro.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(parametri_url) }
#      format.xml  { head :ok }
#    end
#  end
end
