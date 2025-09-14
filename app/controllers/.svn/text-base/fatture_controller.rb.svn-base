class FattureController < ApplicationController
  layout 'admin'
  before_filter :require_admin

  active_scaffold :fattura do |config|
    #columns[:prezzo].description = "Euro"
    #columns[:forfeit].description = "spuntare per Tipologie Rdp a <b>prezzo unico</b>, poi inserire il prezzo"
    #columns[:pie_pagina].description = "il testo che verrà stampato a piè pagina sul rapporto di prova (HTML ammesso)"
    #columns[:note].description = "note interne (non visibili ai clienti)"
    #columns[:data_inizio].description = "inserire la date per l'inserimento automatico dei rapporti non ancora fatturati"
    #columns[:data_fine].description = "" # "(come sopra)"
    columns[:percentuale_sconto].description = "inserire il valore percentuale: da 0 a 100"
    columns[:usa_indirizzo_di_fatturazione].description = "Disattivare <i>solo</i> se l'indirizzo di fatturazione è presente, <i>ma</i> si vuole fatturare all'indirizzo principale"
    columns[:numero].sort_by :sql => 'anno ASC, numero'
    # vedi http://wiki.github.com/activescaffold/active_scaffold/api-nested
    columns[:rapporti].set_link('nested', :parameters => {:associations => :rapporti})

    columns = [
                :dati_fattura_link,
                :stampa_fattura_link,
                :rigenera_pdf_link,
                :cliente,
                :numero,
                :anno,
                :data_emissione,
                #:percentuale_sconto,
                #:data_inizio,
                #:data_fine,
                :pagata,
                #:prove_totali,
                :totale_analisi,   # NECESSARIA... Altrimenti ho un problema di refresh (ed il totale nella list dopo modifica sballa!)
                                   # E deve essere anche prima di rapporti :(
                :rapporti,
                :data_inizio,
                :data_fine,
                #:rapporto,
                :totale,
                :data_pagamento,
                :usa_indirizzo_di_fatturazione,
                :note,
               ]
    config.columns = 	columns
    #config.columns[:fattura_rapporto_items].label = "Rapporti fatturati"
    # la seguente mi renderebbe nulli i link agli elementi has_many
    # config.actions.exclude :nested
    config.list.columns = columns - [:usa_indirizzo_di_fatturazione]
    config.create.columns.exclude  :rapporti, :stampa_fattura_link, :dati_fattura_link,:rigenera_pdf_link, :totale_analisi, :pagata, :data_pagamento, :totale, :percentuale_sconto,  :prove_totali
    config.update.columns.exclude  :rapporti, :stampa_fattura_link, :dati_fattura_link,:rigenera_pdf_link, :totale_analisi, :pagata, :prove_totali, :totale, :percentuale_sconto
    config.subform.columns.exclude :rapporti, :stampa_fattura_link, :dati_fattura_link,:rigenera_pdf_link, :totale_analisi, :pagata, :prove_totali, :totale, :percentuale_sconto
    # vedi http://wiki.github.com/activescaffold/active_scaffold/api-nested
    #config.nested.add_link("Rapporti", [:rapporti])
    # la seguente fa in modo che 'matrice' punti a show (e non ad edit)
    #config.columns[:matrice].set_link('nested', :parameters => {:associations => :matrice})
    # la seguente mi genera link a vuoto
    # config.columns[:matrice].set_link('nested', :parameters => nil)
    config.columns[:numero].label = 'Fatt n.'
    config.columns[:anno].label = 'anno'
    list.per_page = 50
    config.columns[:cliente].form_ui = :select
    list.sorting = [{:data_emissione => :desc}]  
    #config.theme = :blue

  end


   def conditions_for_collection
    # ['user_type IN (?)', ['admin', 'sysop']]
    if params[:fattura_id]
      fattura = Fattura.find_by_id params[:fattura_id].to_i
      return ['`fatture`.`id` IN (?)', [fattura.id]]
    end
    if params[:cliente_id]
      cliente = Cliente.find_by_id(params[:cliente_id].to_i)
      if cliente.nil?
        flash[:error] = 'Attenzione, stai filtrando fatture su un cliente inesistente'
        return false
      else
        if params[:anno].nil?
          flash[:notice] = "(filtrato) Elenco fatture cliente: <strong>#{cliente.nome}</strong>"
          fatture_da_mostrare = cliente.fatture.map {|fattura| fattura.id}
        else
          flash[:notice] = "(filtrato) Elenco fatture cliente: <strong>#{cliente.nome}</strong> per anno: <strong>#{params[:anno]}</strong>"
          fatture_da_mostrare = cliente.fatture.map {|fattura| fattura.id if (fattura.anno == params[:anno].to_i)}
        end
#        if params[:rapporto_anno].nil?
#          ['campione_id IN (?)', campioni_da_mostrare]
#        else
#          #['campione_id IN (?) AND campione.anno = ?', campioni_da_mostrare, 2008]
#          #"user_name = '#{user_name}' AND password = '#{password}'"
#          # attenzione, devo mettere `rapporti` per evitare disambiguita
#          "campione_id IN (#{campioni_da_mostrare.map{|campione| campione.id}}) AND `rapporti`.anno = #{params[:anno].to_i}"
#        end
        return ['`fatture`.`id` IN (?)', fatture_da_mostrare]
      end
    end
  end



  def fattura_per_pdf
    # la seguente per stampa modello vuoto
    # http://localhost:3000/rapporti/rdp/903?format=pdf&stampa_modello_vuoto=1
    if params[:stampa_modello_vuoto]=='1'
      @style_nascosto_se_stampa_modello_vuoto = ' visibility:hidden; '
    else
      @style_nascosto_se_stampa_modello_vuoto = ' visibility:visible; '
    end
    #
    @fattura = Fattura.find(params[:id])
#    if !@fattura.completa?
#      flash[:error] = 'La fattura non è completa.'
#      redirect_to :controller => :fatture
#    elsif @fattura.data_inizio.nil? || @fattura.data_fine.nil?
#      flash[:error] = 'Data esecuzione rapporti mancante'
#      redirect_to :controller => :fatture, :action => :edit, :id => @fattura.id
#    else
      # non genero il render se arrivo da 'invia_email'
      unless  @codice_senza_render
        # determino le unità sulle quali calcolare la fattura
        #  genero un array di array fatto in qesto modo
        #  [43, 120, 3, 5]
        #  [43, 25]
        #  [41, 20, 4, 7, 9]
        #  dove il primo valore è la tipologia_id
        #  il secondo è il prezzo del rapporto con quella tipologia
        #   e gli altri le prove_id ordinate
        #  [tipologia_id, prezzo_rapporto, prova1_id, prova2_id, prova_3_id]
        #  in qeusto modo avrò
        #  [[43, 120, 3, 5], [43, 25], [41, 15, 4, 7, 9],[43, 120, 3, 5]].uniq
        #=> [[43, 120, 3, 5], [43, 25], [41, 15, 4, 7, 9]]     mi dà tutte le tipologie effettivamente diverse ed il loro prezzo
        #  mentre il vettore senza uniq mi serve per calcolare la quantità
        #  [2,4,5,6,7,7,7,4]-[7] => [2, 4, 5, 6, 4] quindi
        #  per sapere quante volte l'elemento 7 è ripetuto in un array calcolo:
        #  [2,4,5,6,7,7,7,4].size - ([2,4,5,6,7,7,7,4]-[7]).size
        #  array.size - (array-element).size
        # ed ho tutte le tipologie diverse, e le quantità di prove ciascuna
        @array_di_array_tipologie_id_prove_id = Array.new
        @fattura.rapporti_ordinati_per_nome_tipologia.each do |rapporto|
          if rapporto.prove_totali.empty?
            # non ci dovrei mai arrivare qui, ma.... non si sa mai
            @array_di_array_tipologie_id_prove_id << [rapporto.tipologia_id]+[rapporto.prezzo_totale]
          else
            @array_di_array_tipologie_id_prove_id << [rapporto.tipologia_id]+[rapporto.prezzo_totale]+rapporto.prove_totali.sort_by{|prova| prova.id}.map{|prova| prova.id}
          end
        end
        # visualizza_rapporto
        respond_to do |format|
          format.html {render :layout => 'fattura'}
          format.pdf do
            # default are
            # layout:      false
            # template:    the template for the current controller/action
            # stylesheets: none
            render :pdf => "fattura_per_pdf", :stylesheets => ["fattura", "prince"], :layout => "fattura"
          end
        end
      end
#    end
  end

  def crea_pdf
    # il presente genera il file pdf, e.. .qualora presente, gli scrive sopra

    #
    fattura = Fattura.find(params[:id])
    if !fattura.completa?
      flash[:error] = 'La fattura non è completa.'
      redirect_to :controller => :fatture
    elsif fattura.data_inizio.nil? || fattura.data_fine.nil?
      flash[:error] = 'Data esecuzione rapporti mancante'
      redirect_to :controller => :fatture, :action => :edit, :id => fattura.id
    else
        # determino le unità sulle quali calcolare la fattura
        #  genero un array di array fatto in qesto modo
        #  [43, 120, 3, 5]
        #  [43, 25]
        #  [41, 20, 4, 7, 9]
        #  dove il primo valore è la tipologia_id
        #  il secondo è il prezzo del rapporto con quella tipologia
        #   e gli altri le prove_id ordinate
        #  [tipologia_id, prezzo_rapporto, prova1_id, prova2_id, prova_3_id]
        #  in qeusto modo avrò
        #  [[43, 120, 3, 5], [43, 25], [41, 15, 4, 7, 9],[43, 120, 3, 5]].uniq
        #=> [[43, 120, 3, 5], [43, 25], [41, 15, 4, 7, 9]]     mi dà tutte le tipologie effettivamente diverse ed il loro prezzo
        #  mentre il vettore senza uniq mi serve per calcolare la quantità
        #  [2,4,5,6,7,7,7,4]-[7] => [2, 4, 5, 6, 4] quindi
        #  per sapere quante volte l'elemento 7 è ripetuto in un array calcolo:
        #  [2,4,5,6,7,7,7,4].size - ([2,4,5,6,7,7,7,4]-[7]).size
        #  array.size - (array-element).size
        # ed ho tutte le tipologie diverse, e le quantità di prove ciascuna
        array_di_array_tipologie_id_prove_id = Array.new
        fattura.rapporti_ordinati_per_nome_tipologia.each do |rapporto|
          if rapporto.prove_totali.empty?
            # non ci dovrei mai arrivare qui, ma.... non si sa mai
            array_di_array_tipologie_id_prove_id << [rapporto.tipologia_id]+[rapporto.prezzo_totale]
          else
            array_di_array_tipologie_id_prove_id << [rapporto.tipologia_id]+[rapporto.prezzo_totale]+rapporto.prove_totali.sort_by{|prova| prova.id}.map{|prova| prova.id}
          end
        end
        fattura.pdf_elimina if fattura.pdf_esiste?
        @codice_senza_render = true
        fattura_per_pdf
        fattura_per_pdf = make_pdf(:template => "fatture/fattura_per_pdf.erb",  :pdf => "fattura", :stylesheets => ["fattura", "prince"], :layout => "fattura")
        out = fattura_per_pdf
        nome_file = fattura.nome_file_pdf_della_fattura_con_path_assoluto
        File.open(nome_file, 'w') do |f|
          f.write(out)
        end

#        # visualizza_rapporto
#        respond_to do |format|
#          format.html {render :layout => 'fattura'}
#          format.pdf do
#            # default are
#            # layout:      false
#            # template:    the template for the current controller/action
#            # stylesheets: none
#            render :pdf => "fattura", :stylesheets => ["fattura", "prince"], :layout => "fattura"
#          end
#        end
      flash[:error] = 'Pdf creato'
      redirect_to :controller => :fatture#, :action => :show, :id => fattura.id

    end
  end


  def mostra_pdf
    fattura = Fattura.find(params[:id])
    nome_file = fattura.nome_file_pdf_della_fattura_con_path_assoluto
    if File.exist?(nome_file)
      file_data = IO.read(nome_file)
  #    File.open(filename, 'r') do |f|
  #      file_data = f.readlines
  #    end
      send_data(
        file_data,
        :filename => nome_file,
        :type => 'application/pdf'
      )
    else
      raise "Errore: stai tentando di visualizzare un PDF inesistente (fattura n.#{fattura.numero}, id=#{fattura.id}). Avvertire Francesco"
    end
  end








#  # GET /fatture
#  # GET /fatture.xml
#  def index
#    @fatture = Fattura.all
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @fatture }
#    end
#  end
#
#  # GET /fatture/1
#  # GET /fatture/1.xml
#  def show
#    @fattura = Fattura.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @fattura }
#    end
#  end
#
#  # GET /fatture/new
#  # GET /fatture/new.xml
#  def new
#    @fattura = Fattura.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @fattura }
#    end
#  end
#
#  # GET /fatture/1/edit
#  def edit
#    @fattura = Fattura.find(params[:id])
#  end
#
#  # POST /fatture
#  # POST /fatture.xml
#  def create
#    @fattura = Fattura.new(params[:fattura])
#
#    respond_to do |format|
#      if @fattura.save
#        format.html { redirect_to(@fattura, :notice => 'Fattura was successfully created.') }
#        format.xml  { render :xml => @fattura, :status => :created, :location => @fattura }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @fattura.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # PUT /fatture/1
#  # PUT /fatture/1.xml
#  def update
#    @fattura = Fattura.find(params[:id])
#
#    respond_to do |format|
#      if @fattura.update_attributes(params[:fattura])
#        format.html { redirect_to(@fattura, :notice => 'Fattura was successfully updated.') }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @fattura.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # DELETE /fatture/1
#  # DELETE /fatture/1.xml
#  def destroy
#    @fattura = Fattura.find(params[:id])
#    @fattura.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(fatture_url) }
#      format.xml  { head :ok }
#    end
#  end
end
