class MatriciController < ApplicationController
  layout 'admin'
  before_filter :require_admin_or_operator
  

  active_scaffold :matrice do |config|

    #columns[:nome].description = "nome breve"
    columns = [
                :nome,
                :nome_esteso,
                :variabili,
                :prove,
                :tipologie,
                #:udm_items, non la posso avere, visto che ci sono variabili senza udm, e quindi senza matrice dedotta da queste
               ]
    config.columns = 	columns
    config.list.columns = columns
    config.create.columns.exclude :prove, :tipologie, :variabili
    config.update.columns.exclude :prove, :tipologie, :variabili
    #config.subform.columns.exclude :nome, :nome_esteso
    list.sorting = {:nome => :asc}
    #config.nested.add_link("Show contacts/projects", [:variabili, :prove])
  end

#  # GET /matrici
#  # GET /matrici.xml
#  def index
#    @matrici = Matrice.all
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @matrici }
#    end
#  end
#
#  # GET /matrici/1
#  # GET /matrici/1.xml
#  def show
#    @matrice = Matrice.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @matrice }
#    end
#  end
#
#  # GET /matrici/new
#  # GET /matrici/new.xml
#  def new
#    @matrice = Matrice.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @matrice }
#    end
#  end
#
#  # GET /matrici/1/edit
#  def edit
#    @matrice = Matrice.find(params[:id])
#  end
#
#  # POST /matrici
#  # POST /matrici.xml
#  def create
#    @matrice = Matrice.new(params[:matrice])
#
#    respond_to do |format|
#      if @matrice.save
#        flash[:notice] = 'Matrice was successfully created.'
#        format.html { redirect_to(@matrice) }
#        format.xml  { render :xml => @matrice, :status => :created, :location => @matrice }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @matrice.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # PUT /matrici/1
#  # PUT /matrici/1.xml
#  def update
#    @matrice = Matrice.find(params[:id])
#
#    respond_to do |format|
#      if @matrice.update_attributes(params[:matrice])
#        flash[:notice] = 'Matrice was successfully updated.'
#        format.html { redirect_to(@matrice) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @matrice.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # DELETE /matrici/1
#  # DELETE /matrici/1.xml
#  def destroy
#    @matrice = Matrice.find(params[:id])
#    @matrice.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(matrici_url) }
#      format.xml  { head :ok }
#    end
#  end
end
