class CampioniController < ApplicationController
  layout 'admin'
  before_filter :require_admin_or_operator
  

  active_scaffold :campione do |config|
#    columns[:ettari].description = "Ha"
#    columns[:ettari].description = "Ha"
    columns[:note].description = "note interne (non visibili ai clienti)"
    columns[:numero].sort_by :sql => 'anno ASC, numero'
    columns = [
                :nuovo_rapporto_link,
                :duplica_campione_link,
                :cliente,
                :campione_di,
                :etichetta,
                :nome_richiedente,
                :numero,
                :anno,
                :data,
                :suggello,
                :campionamento,
                :non_conforme_motivo,
                :comune,
                :provincia,
                :località,
                :tipo_di_coltura,
                :fase_coltura,
                :ettari,
                :superficie_di_prelievo,
                :profondita_di_prelievo,
                :numero_foglio_di_mappa,
                :particelle,
                :note,
                :tipologie,
                :rapporti,
               ]
    config.columns = 	columns
    config.list.columns = columns - [:etichetta,
                                     :nome_richiedente,
                                     :suggello,
                                     :campionamento,
                                     :non_conforme_motivo,
                                      :comune,
                                      :provincia,
                                      :località,
                                      :tipo_di_coltura,
                                      :fase_coltura,
                                      :ettari,
                                      :superficie_di_prelievo,
                                      :profondita_di_prelievo,
                                      :numero_foglio_di_mappa,
                                      :particelle,
                                     ]
    
    #config.create.columns.exclude :tipologia_campione_items # necessario in quando non ho campione_id

    config.create.columns.exclude  :rapporti # necessario, in quanto non ho l'ID
    config.create.columns.exclude  :tipologie, :non_conforme_motivo, :nuovo_rapporto_link, :duplica_campione_link
    config.update.columns.exclude  :tipologie, :rapporti, :nuovo_rapporto_link, :duplica_campione_link
    config.subform.columns.exclude :non_conforme_motivo, :nuovo_rapporto_link, :duplica_campione_link
    #config.update.columns.exclude :tipologie, :status
    #config.columns[:rapporti].form_ui = :select
    config.columns[:cliente].form_ui = :select
    config.columns[:numero].label = 'Rc numero'
    config.columns[:anno].label   = 'Rc anno'
    config.columns[:ettari].label = 'Ettari (Ha)'
    config.columns[:note].label = "Note interne"
    config.columns[:superficie_di_prelievo].label = 'Superficie di Prelievo (Ha)'
    config.columns[:particelle].label = 'Particella/e'
    config.columns[:numero_foglio_di_mappa].label = 'Foglio_di_mappa n°'
    config.columns[:profondita_di_prelievo].label = 'Profondità di Prelievo'
    config.columns[:duplica_campione_link].label = 'Dup'    
    list.sorting = {:numero => :desc} # TODO ordina per anno
    list.per_page = 50
    # ricerca - aggiungo numero
    # nota... devo aggiungere `campioni`. per evitare ambiguità
    config.columns[:numero].search_sql = '`campioni`.numero'
    config.columns[:anno].search_sql = '`campioni`.anno'
    config.search.columns << :numero
    config.search.columns << :anno
    #
    config.theme = :blue
  end

#  # GET /campioni
#  # GET /campioni.xml
#  def index
#    @campioni = Campione.all
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @campioni }
#    end
#  end
#
#  # GET /campioni/1
#  # GET /campioni/1.xml
#  def show
#    @campione = Campione.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @campione }
#    end
#  end
#
#  # GET /campioni/new
#  # GET /campioni/new.xml
#  def new
#    @campione = Campione.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @campione }
#    end
#  end
#
#  # GET /campioni/1/edit
#  def edit
#    @campione = Campione.find(params[:id])
#  end
#
#  # POST /campioni
#  # POST /campioni.xml
#  def create
#    @campione = Campione.new(params[:campione])
#
#    respond_to do |format|
#      if @campione.save
#        flash[:notice] = 'Campione was successfully created.'
#        format.html { redirect_to(@campione) }
#        format.xml  { render :xml => @campione, :status => :created, :location => @campione }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @campione.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # PUT /campioni/1
#  # PUT /campioni/1.xml
#  def update
#    @campione = Campione.find(params[:id])
#
#    respond_to do |format|
#      if @campione.update_attributes(params[:campione])
#        flash[:notice] = 'Campione was successfully updated.'
#        format.html { redirect_to(@campione) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @campione.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # DELETE /campioni/1
#  # DELETE /campioni/1.xml
#  def destroy
#    @campione = Campione.find(params[:id])
#    @campione.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(campioni_url) }
#      format.xml  { head :ok }
#    end
#  end
end
