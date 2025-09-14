class ProveController < ApplicationController
  layout 'admin'
  before_filter :require_admin_or_operator
  

  active_scaffold :prova do |config|
    columns[:prezzo].description = "Prezzo di quando la prova fa parte di una tipologia non a forfeit (altrimenti è ignorato)"
    columns[:nome_esteso].description = "Dicitura che comparirà nel Rapporto di Prova"
    columns[:note].description = "note interne (non visibili ai clienti)"
    columns = [
                :nome,
                :nome_esteso,
                :matrice,
                :metodo_di_prova,
                :subappalto,
                :prezzo,
                :note,
                #:variabili,
                :prova_variabile_items,
                #:tipologie,
                :prova_tipologia_items,
                #:campioni,
               ]
    config.columns = 	columns
    # la seguente mi renderebbe nulli i link agli elementi has_many
    #config.actions.exclude :nested
    config.list.columns = columns
    config.columns[:prova_variabile_items].label = "Variabili da mostrare"
    config.columns[:prova_tipologia_items].label = "Tipologie che la includono"
    config.columns[:note].label = "Note interne"
    config.columns[:prezzo].label = "Prezzo <br/>(se somma analisi)"
    config.create.columns.exclude :prova_variabile_items #NECESSARIO, in quando non ho la prova_id necessaria
    config.create.columns.exclude :prova_tipologia_items #NECESSARIO, in quando non ho la prova_id necessaria
    config.create.columns.exclude :variabili, :tipologie, :campioni
    config.update.columns.exclude :variabili # NECESSARIO (altimenti mi potrebbe cambiare il contenuto delle variabili)
    config.update.columns.exclude :tipologie # NECESSARIO (altimenti mi potrebbe cambiare il contenuto delle tipologie)
    config.update.columns.exclude :campioni # NECESSARIO (altimenti mi potrebbe cambiare il contenuto dei campioni)
    config.update.columns.exclude :prova_tipologia_items
    config.columns[:matrice].form_ui = :select
    #config.columns[:prova_variabile_items].form_ui = :select

    # la seguente fa in modo che 'matrice' punti a show (e non ad edit)
    #config.columns[:matrice].set_link('nested', :parameters => {:associations => :matrice})
    # la seguente mi genera link a vuoto
    config.columns[:matrice].set_link('nested', :parameters => nil)


    config.subform.columns.exclude :matrice, :subappalto

    #config.columns[:campioni].form_ui = :select
    #list.sorting = {:nome => :asc}
    list.sorting =  [{:matrice_id => :desc}, {:nome => :asc}]
  end

#  # GET /prove
#  # GET /prove.xml
#  def index
#    @prove = Prova.all
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @prove }
#    end
#  end
#
#  # GET /prove/1
#  # GET /prove/1.xml
#  def show
#    @prova = Prova.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @prova }
#    end
#  end
#
#  # GET /prove/new
#  # GET /prove/new.xml
#  def new
#    @prova = Prova.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @prova }
#    end
#  end
#
#  # GET /prove/1/edit
#  def edit
#    @prova = Prova.find(params[:id])
#  end
#
#  # POST /prove
#  # POST /prove.xml
#  def create
#    @prova = Prova.new(params[:prova])
#
#    respond_to do |format|
#      if @prova.save
#        flash[:notice] = 'Prova was successfully created.'
#        format.html { redirect_to(@prova) }
#        format.xml  { render :xml => @prova, :status => :created, :location => @prova }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @prova.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # PUT /prove/1
#  # PUT /prove/1.xml
#  def update
#    @prova = Prova.find(params[:id])
#
#    respond_to do |format|
#      if @prova.update_attributes(params[:prova])
#        flash[:notice] = 'Prova was successfully updated.'
#        format.html { redirect_to(@prova) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @prova.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # DELETE /prove/1
#  # DELETE /prove/1.xml
#  def destroy
#    @prova = Prova.find(params[:id])
#    @prova.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(prove_url) }
#      format.xml  { head :ok }
#    end
#  end
end
