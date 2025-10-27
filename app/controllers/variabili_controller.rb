class VariabiliController < ApplicationController
  layout 'admin'
  before_filter :require_admin_or_operator
  #debugger

  active_scaffold :variabile do |config|

#    config.actions = [
#                      :create, # NEW
#                      :list,
#                      :update,
#                      #:subform,
#                      :delete,
#                      :show,
#                      #:nested,  #
#                      :search,
#                      ]
    # config.nested.columns = [...] ESISTE!
    #config.nested.columns = [
             #                :udm_item
                  #           ]
    #config.show.columns = [:udm_item]
    #config.columns[:udm_item].set_link "../link_action"
    #config.show.link = 'ciccio'
    #config.action_links.add 'reply_to_message', :label => 'Reply', :type => :record, :page => true
    #config.show.link.crud_type

    columns[:nome_esteso].description = "E' l'etichetta che verrà stampata nei rapporti di prova, a fianco rispettivo valore. (Apice <sup>(<small>1</small>)</sup>, Pedice: <sub>k</sub>) "
    columns[:simbolo].description = "La colonna del foglio Excel (per colonna J su secondo foglio aggiungi 'ZZ' e scrivi: ZZJ, ZZAB,..)"
    columns[:funzione].description = 'Esempio  "B+(AD*0.26)-H**(1/2)" -- con B,AD,H definite in precedenza (Nb. elevazione a potenza con "**")'
    columns[:decimali].description = 'Dati di OUTPUT: numero decimali da visualizzare -- Dati di INPUT: numero decimali da chiedere'
    columns[:max].description = 'Massimo valore possibile.  Per valori superiori viene segnalato un errore di inserimento o calcolo'
    columns[:min].description = 'Minimo valore possibile.  Per valori inferiori viene segnalato un errore di inserimento o calcolo'
    columns = [
                :nome,
                :nome_esteso,
                :matrice,
                :tipo,
                :simbolo,
                :funzione,
                :variabili_coinvolte_in_words,
                :funzione_decodificata,
                :funzione_sviluppata,
                :funzione_sviluppata_decodificata,
                # DEBUG
                #:variabili_indipendenti_tutte_presenti?,
                #:variabili_indipendenti_assenti,
                #:funzione_corretta,
                #:funzione_ok,
                :unita_di_misura,
                :decimali,
                :min,
                :max,
                #:forza_zero,
                :note,
                :udm_item,
                #:prove,
                :prova_variabile_items,
               ]
    config.columns = 	columns
    # la seguente mi renderebbe nulli i link agli elementi has_many
    #config.actions.exclude :nested

    config.list.columns = columns - [:udm_item]
    config.columns[:prova_variabile_items].label = 'Prove che la includono'
    #config.list.columns.exclude :udm_item
    config.create.columns.exclude :unita_di_misura
    config.update.columns.exclude :unita_di_misura
    #config.show.exclude :matrice
    config.create.columns.exclude :prova_variabile_items # necessario in quando non ho variabile_id
    config.create.columns.exclude :prove
    config.update.columns.exclude :prova_variabile_items # farebbe casino
    config.update.columns.exclude :prove    # farebbe casino
    #
    config.list.columns.exclude   :funzione_sviluppata, :funzione_sviluppata_decodificata, :funzione_decodificata, :variabili_coinvolte_in_words
    config.create.columns.exclude :funzione_sviluppata, :funzione_sviluppata_decodificata, :funzione_decodificata, :variabili_coinvolte_in_words
    config.update.columns.exclude :funzione_sviluppata, :funzione_sviluppata_decodificata, :funzione_decodificata, :variabili_coinvolte_in_words
    #DEBUG
    #config.create.columns.exclude :variabili_indipendenti_tutte_presenti?, :variabili_indipendenti_assenti
    #config.update.columns.exclude :variabili_indipendenti_tutte_presenti?, :variabili_indipendenti_assenti
    #
    #config.create.columns.exclude :prove
    #config.update.columns.exclude :campioni
    config.columns[:matrice].form_ui = :select
    # RIMETTIconfig.columns[:udm_item].form_ui = :select
    #config.columns[:matrice].
    #config.columns[:prova_variabile_items].form_ui = :select
    config.columns[:udm_item].label = 'Unità di Misura'

    #config.list.empty_field_text = '[vuoto]'
    #list.sorting = {:nome => :asc}
    # default sorting: descending on title, then ascending on subtitle
    #config.list.sorting = [{ :title => :desc}, {:subtitle => :asc}]

    # la seguente fa in modo che 'matrice' punti a show (e non ad edit)
    #config.columns[:matrice].set_link('nested', :parameters => {:associations => :matrice})
    # la seguente mi genera link a vuoto
    config.columns[:matrice].set_link('nested', :parameters => nil)

    config.subform.columns.exclude :matrice, :simbolo, :decimali, :tipo

    list.per_page = 1000
    list.sorting =  [{:matrice_id => :desc}, {:simbolo => :asc}]
    
  end
  


#  # GET /variabili
#  # GET /variabili.xml
#  def index
#    @variabili = Variabile.all
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @variabili }
#    end
#  end
#
#  # GET /variabili/1
#  # GET /variabili/1.xml
#  def show
#    @variabile = Variabile.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @variabile }
#    end
#  end
#
#  # GET /variabili/new
#  # GET /variabili/new.xml
#  def new
#    @variabile = Variabile.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @variabile }
#    end
#  end
#
#  # GET /variabili/1/edit
#  def edit
#    @variabile = Variabile.find(params[:id])
#  end
#
#  # POST /variabili
#  # POST /variabili.xml
#  def create
#    @variabile = Variabile.new(params[:variabile])
#
#    respond_to do |format|
#      if @variabile.save
#        flash[:notice] = 'Variabile was successfully created.'
#        format.html { redirect_to(@variabile) }
#        format.xml  { render :xml => @variabile, :status => :created, :location => @variabile }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @variabile.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # PUT /variabili/1
#  # PUT /variabili/1.xml
#  def update
#    @variabile = Variabile.find(params[:id])
#
#    respond_to do |format|
#      if @variabile.update_attributes(params[:variabile])
#        flash[:notice] = 'Variabile was successfully updated.'
#        format.html { redirect_to(@variabile) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @variabile.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # DELETE /variabili/1
#  # DELETE /variabili/1.xml
#  def destroy
#    @variabile = Variabile.find(params[:id])
#    @variabile.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(variabili_url) }
#      format.xml  { head :ok }
#    end
#  end
end
