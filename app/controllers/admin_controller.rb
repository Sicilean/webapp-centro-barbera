class AdminController < ApplicationController
  layout 'admin'
  before_filter :require_admin_or_operator

  def index
    if params[:anno].nil?
      @anno = DateTime.now.year
    else
      @anno = params[:anno].to_i
    end

    if params[:mostra_clienti_test].nil?
      @mostra_clienti_test = false
    else
      @mostra_clienti_test = true
    end

    # condizione di base
    condizioni = "(status = '#{RAPPORTO_STATUS_DEFAULT}' OR numero IS NULL) "

    # condizione per l'anno scelto
    condizioni += " AND ((anno=#{@anno}) OR (created_at >= '#{@anno}-01-01 00:00:00' AND created_at < '#{@anno+1}-01-01 00:00:00'))"

    # escludo dei rapporti errati del 2010 che non vogliono visualizzare (quelli fino al 1034 compreso.. che escludo con l'artificio del created at)
    if @anno == 2010
      condizioni += " AND (created_at > '2010-09-03 11:00:24')"
    end

    @rapporti_non_pronti = Rapporto.find(:all,
                                              # originale
                                              #:conditions =>  "(status = '#{RAPPORTO_STATUS_DEFAULT}' OR numero IS NULL)",
                                              # modificata per escludere rapporti 2010 modificati nel tempo
                                              #:conditions =>  "(status = '#{RAPPORTO_STATUS_DEFAULT}' OR numero IS NULL) AND NOT (anno!=2010 AND numero<94)",
                                              #:conditions =>  "(status = '#{RAPPORTO_STATUS_DEFAULT}' OR numero IS NULL) AND (anno=#{anno} OR IS NULL ) AND NOT (anno=2010 AND ((numero IS NOT NULL) AND numero<=1034))",
                                              :conditions =>  condizioni,
                                              :order => 'data_scadenza, created_at DESC')
      # i rapporti non pronti sono quelli 'in lavorazione' oppure con 'numero rdp mancante'
  end

  def clienti_con_rapporti_in_sospeso

    #
    @anno = params[:anno].to_i
    @anno = Time.now.year if @anno == 0

    condizioni  = "(fattura_id IS NULL) AND (data_stampa IS NOT NULL) "
    condizioni += " AND data_stampa >= '#{@anno}-01-01 00:00:00'   "
    condizioni += " AND data_stampa <  '#{@anno+1}-01-01 00:00:00' "

    @rapporti_da_fatturare = Rapporto.find(:all,
                                            #:conditions =>  "(fattura_id IS NULL) AND (data_stampa IS NOT NULL) ")
                                            :conditions =>  condizioni
                                            )

    @tabella = Hash.new
    # {cliente_id => {:data_inizio, :data_fine, :imponibile}}
    # es. {23=>{:data_inizio => '21-12-2010, :data_fine => '23-23-2010', :imponibile => 540}}

    @rapporti_da_fatturare.each do |rapporto|
      cliente_id = rapporto.cliente.id
      if @tabella[cliente_id].nil?
        @tabella[cliente_id] = Hash.new
        @tabella[cliente_id][:cliente_nome] = rapporto.cliente.nome
        @tabella[cliente_id][:data_inizio]  = rapporto.data_stampa
        @tabella[cliente_id][:data_fine]    = rapporto.data_stampa
        @tabella[cliente_id][:imponibile]   = rapporto.prezzo_totale
      else
        @tabella[cliente_id][:data_inizio]  = rapporto.data_stampa if rapporto.data_stampa < @tabella[cliente_id][:data_inizio]
        @tabella[cliente_id][:data_fine]    = rapporto.data_stampa if rapporto.data_stampa > @tabella[cliente_id][:data_fine]
        @tabella[cliente_id][:imponibile]   = @tabella[cliente_id][:imponibile] + rapporto.prezzo_totale
      end
    end

  end

  def controllo_rapporti_con_dati_mancanti_con_status_completo
    @rapporti_non_pronti = Rapporto.find(:all,
                                            :conditions =>  "status = 'completo'",
                                            :order => 'data_scadenza ASC')
    @rapporti_non_pronti.delete_if {|rapporto| rapporto.variabile_rapporto_items_mancanti.size == 0 }
  end

  def cerca_rapporti

    select_vuoto = [['' , '']]
    @options_for_giorni          = select_vuoto + [['7 gg' , '7'],
                                               ['15 gg', '15'],
                                               ['30 gg', '30']]
    @options_for_cliente_id      = select_vuoto + Cliente.all.map{|cliente| [cliente.nome, "#{cliente.id}"] }.sort
    @options_for_rapporto_status = select_vuoto + [['completo' , 'completo'],
                                                   ['in lavorazione', 'in lavorazione']]
    @options_for_rapporto_sms    = select_vuoto + [['inviato'    , 'si'],
                                                   ['non inviato', 'no']]
    @options_for_rapporto_email  = @options_for_rapporto_sms
    @options_for_tipo_invio      = select_vuoto + [['invio email', 'email'],
                                                   ['invio sms'    , 'sms'],
                                                   ['conteggio rapporti','conteggio'],
                                                   ]
    @options_for_da_fatturare    = select_vuoto + [['da fatturare' , 'si'],
                                                   ['fatturati'    , 'no']]

    default_giorni          = @options_for_giorni          [1][1]
    default_giorni_rapporto = @options_for_giorni          [0][1]
    default_cliente_id      = @options_for_cliente_id      [0][1]
    default_rapporto_status = @options_for_rapporto_status [1][1]
    default_rapporto_sms    = @options_for_rapporto_sms    [0][1]
    default_rapporto_email  = @options_for_rapporto_email  [0][1]
    default_tipo_invio      = @options_for_tipo_invio      [1][1]
    default_da_fatturare    = @options_for_da_fatturare    [0][1]

#    default_data_da         = "1/1/#{Time.now.year}".to_date
#    default_data_a          = Time.now.to_date
#    my_date = Time.today + 6.days


    # ricavo le date
    unless (params[:da].nil? || (params[:da]['data(2i)']+params[:da]['data(3i)']+params[:da]['data(1i)']).blank?)
      data_da_stringa = "#{params[:da]['data(2i)'].blank? ? 1 : params[:da]['data(2i)']}/#{params[:da]['data(3i)'].blank? ? 1 : params[:da]['data(3i)']}/#{params[:da]['data(1i)'].blank? ? Time.now.year : params[:da]['data(1i)'] }"
      if stringa_per_data_valida?(data_da_stringa)
        @data_da = data_da_stringa.to_date
      else
        @data_da = nil
      end
    end
    unless (params[:a].nil? || (params[:a]['data(2i)']+params[:a]['data(3i)']+params[:a]['data(1i)']).blank?)
      data_a_stringa = "#{params[:a]['data(2i)'].blank? ? 1 : params[:a]['data(2i)']}/#{params[:a]['data(3i)'].blank? ? 1 : params[:a]['data(3i)']}/#{params[:a]['data(1i)'].blank? ? Time.now.year : params[:a]['data(1i)'] }"
      if stringa_per_data_valida?(data_a_stringa)
        @data_a = data_a_stringa.to_date
      else
        @data_a = nil
      end
    end

    unless (params[:da_rapporto].nil? || (params[:da_rapporto]['data(2i)']+params[:da_rapporto]['data(3i)']+params[:da_rapporto]['data(1i)']).blank?)
      data_da_rapporto_stringa = "#{params[:da_rapporto]['data(2i)'].blank? ? 1 : params[:da_rapporto]['data(2i)']}/#{params[:da_rapporto]['data(3i)'].blank? ? 1 : params[:da_rapporto]['data(3i)']}/#{params[:da_rapporto]['data(1i)'].blank? ? Time.now.year : params[:da_rapporto]['data(1i)'] }"
      if stringa_per_data_valida?(data_da_rapporto_stringa)
        @data_da_rapporto = data_da_rapporto_stringa.to_date
      else
        @data_da_rapporto = nil
      end
    end
    unless (params[:a_rapporto].nil? || (params[:a_rapporto]['data(2i)']+params[:a_rapporto]['data(3i)']+params[:a_rapporto]['data(1i)']).blank?)
      data_a_rapporto_stringa = "#{params[:a_rapporto]['data(2i)'].blank? ? 1 : params[:a_rapporto]['data(2i)']}/#{params[:a_rapporto]['data(3i)'].blank? ? 1 : params[:a_rapporto]['data(3i)']}/#{params[:a_rapporto]['data(1i)'].blank? ? Time.now.year : params[:a_rapporto]['data(1i)'] }"
      if stringa_per_data_valida?(data_a_rapporto_stringa)
        @data_a_rapporto = data_a_rapporto_stringa.to_date
      else
        @data_a_rapporto = nil
      end
    end


    ## aggiusto casi di date mancanti
    @data_a = Time.now.to_date if (@data_a.nil?  && !@data_da.nil?)
    @data_da = nil             if (@data_da.nil? && !@data_a.nil?)

    ## aggiusto casi di date mancanti
    @data_a_rapporto = Time.now.to_date if (@data_a_rapporto.nil?  && !@data_da_rapporto.nil?)
    @data_da_rapporto = nil             if (@data_da_rapporto.nil? && !@data_a_rapporto.nil?)



    (params[:rapporto_status] = @options_for_rapporto_status [1][1]) unless (params[:giorni_rapporto].blank? && @data_da_rapporto.nil? && @data_a_rapporto.nil?)

    session[:giorni]           = params[:giorni]           || session[:giorni]          || default_giorni
    session[:giorni_rapporto]  = params[:giorni_rapporto]  || session[:giorni_rapporto] || default_giorni_rapporto
    session[:cliente_id]       = params[:cliente_id]       || session[:cliente_id]      || default_cliente_id
    session[:rapporto_status]  = params[:rapporto_status]  || session[:rapporto_status] || default_rapporto_status
    session[:rapporto_sms]     = params[:rapporto_sms]     || session[:rapporto_sms]    || default_rapporto_sms
    session[:rapporto_email]   = params[:rapporto_email]   || session[:rapporto_email]  || default_rapporto_email
    session[:tipo_invio]       = params[:tipo_invio]       || session[:tipo_invio]      || default_tipo_invio
    session[:da_fatturare]     = params[:da_fatturare]     || session[:da_fatturare]    || default_da_fatturare

    giorni           = session[:giorni]
    giorni_rapporto  = session[:giorni_rapporto]
    cliente_id       = session[:cliente_id]
    rapporto_status  = session[:rapporto_status]
    rapporto_sms     = session[:rapporto_sms]
    rapporto_email   = session[:rapporto_email]
    tipo_invio       = session[:tipo_invio]
    da_fatturare     = session[:da_fatturare]

    conditions = "1 "

    unless rapporto_status.blank?
      conditions += " AND status = '#{rapporto_status}'"
    end
    unless rapporto_sms.blank?
      if rapporto_sms == 'si'
        conditions += " AND data_invio_sms IS NOT NULL"
      else
        conditions += " AND data_invio_sms IS NULL"
      end
    end
    unless rapporto_email.blank?
      if rapporto_email == 'si'
        conditions += " AND data_invio_email IS NOT NULL"
      else
        conditions += " AND data_invio_email IS NULL"
      end
    end
    if request.method == :get && params[:mostra] !='si'
      @rapporti = Array.new
    else
      # request.method == :post
      @rapporti = Rapporto.find(:all,
                                              :conditions =>  conditions,
                                              :order => 'data_richiesta DESC')
      ### 
      # cancella rapporti che non hanno data campione rispondente alle richieste
      if !@data_da.nil? && !@data_a.nil?
        # conditions += " AND updated_at > '#{@data_da.strftime("%Y-%m-%d 00:00:00")}' AND updated_at < '#{@data_a.strftime("%Y-%m-%d 23:59:59")}'"
        @rapporti.delete_if{|rapporto| rapporto.campione.data < @data_da || rapporto.campione.data > @data_a}
        flash[:notice] = "Elenco rapporti con data campione dal #{@data_da.strftime("%d-%m-%Y")} al  #{@data_a.strftime("%d-%m-%Y")}"
      elsif !giorni.blank?
        search_date =  (Time.now - (60*60*24*giorni.to_i)).to_date
        #search_date = (Time.now - (60*60*24*giorni.to_i)).strftime("%Y-%m-%d 00:00:00")
        @rapporti.delete_if{|rapporto| rapporto.campione.data < search_date }
        flash[:notice] = "Elenco rapporti con data campione di #{giorni} giorni fa"
        #conditions += " AND updated_at > '#{search_date}'"
      end

      # cancella rapporti che non hanno data rapporto rispondente alle richieste
      if !@data_da_rapporto.nil? && !@data_a_rapporto.nil?
        # conditions += " AND updated_at > '#{@data_da.strftime("%Y-%m-%d 00:00:00")}' AND updated_at < '#{@data_a.strftime("%Y-%m-%d 23:59:59")}'"
        @rapporti.delete_if{|rapporto| (rapporto.data_stampa.nil? || (rapporto.data_stampa < @data_da_rapporto || rapporto.data_stampa > @data_a_rapporto))}
        flash[:notice] = "Elenco rapporti con 'data di stampa rapporto' dal #{@data_da_rapporto.strftime("%d-%m-%Y")} al  #{@data_a_rapporto.strftime("%d-%m-%Y")}"
      elsif !giorni_rapporto.blank?
        search_date =  (Time.now - (60*60*24*giorni_rapporto.to_i)).to_date
        #search_date = (Time.now - (60*60*24*giorni.to_i)).strftime("%Y-%m-%d 00:00:00")
        @rapporti.delete_if{|rapporto| (rapporto.data_stampa.nil? || (rapporto.data_stampa < search_date)) }
        flash[:notice] = "Elenco rapporti con 'data di stampa rapporto' di #{giorni_rapporto} giorni fa"
        #conditions += " AND updated_at > '#{search_date}'"
      end
      ###
      unless cliente_id.blank?
        @rapporti.delete_if { |rapporto| rapporto.campione.cliente.id !=  cliente_id.to_i }
      end
      ## rapporti da fatturare?
      if da_fatturare == 'si'
        @rapporti.delete_if{|rapporto| rapporto.fattura }
      elsif da_fatturare == 'no'
        @rapporti.delete_if{|rapporto| rapporto.fattura.nil? }
      end

      if tipo_invio == 'conteggio'
        @sommatoria_prezzo_totale = 0
        @conteggio_tipologie = Hash.new #
        @conteggio_prove_tipologie_forfeit = Hash.new     # {prova_id => 12}
        @conteggio_prove_aggiuntive = Hash.new     # {prova_id => 12}

        @rapporti.each do |rapporto|
          @sommatoria_prezzo_totale += rapporto.prezzo_totale
          @conteggio_tipologie[rapporto.tipologia.id] = (@conteggio_tipologie[rapporto.tipologia.id] || 0) + 1
          unless rapporto.tipologia.forfeit
            rapporto.tipologia.prove.each do |prova|
              @conteggio_prove_tipologie_forfeit[prova.id] = (@conteggio_prove_tipologie_forfeit[prova.id] || 0) + 1
            end
          end
          rapporto.prova_rapporto_items.each do |prova_rapporto_item|
              @conteggio_prove_aggiuntive[prova_rapporto_item.prova.id] = (@conteggio_prove_aggiuntive[prova_rapporto_item.prova.id] || 0) + 1
          end
        end
      end
    end
  end

  def cerca_fatture

    select_vuoto = [['' , '']]
    @sommatoria_prezzo_totale = 0

    @options_for_giorni          = select_vuoto + [['7 gg' , '7'],
                                               ['15 gg', '15'],
                                               ['30 gg', '30']]
    @options_for_cliente_id      = select_vuoto + Cliente.all.map{|cliente| [cliente.nome, "#{cliente.id}"] }.sort

    @options_for_tipo_elenco     = select_vuoto + [['tabulato', 'tabulato']]
    @options_for_da_pagare    = select_vuoto + [['da pagare' , 'si'],
                                                   ['pagate'    , 'no']]

    default_giorni          = @options_for_giorni          [1][1]
    default_cliente_id      = @options_for_cliente_id      [0][1]
    default_tipo_elenco     = @options_for_tipo_elenco      [0][1]
    default_da_pagare       = @options_for_da_pagare       [1][1]


#    default_data_da         = "1/1/#{Time.now.year}".to_date
#    default_data_a          = Time.now.to_date
#    my_date = Time.today + 6.days


    session[:giorni]           = params[:giorni]           || session[:giorni]          || default_giorni
    session[:cliente_id]       = params[:cliente_id]       || session[:cliente_id]      || default_cliente_id
    # session[:tipo_elenco]      = params[:tipo_elenco]      || session[:tipo_elenco]     || default_tipo_elenco
    session[:da_pagare]        = params[:da_pagare]        || session[:da_pagare]       || default_da_pagare

    giorni           = session[:giorni]
    cliente_id       = session[:cliente_id]
    da_pagare        = session[:da_pagare]
    tipo_elenco      = session[:tipo_elenco]

    conditions = "1 "

    # ricavo le date
    unless (params[:da].nil? || (params[:da]['data(2i)']+params[:da]['data(3i)']+params[:da]['data(1i)']).blank?)
      data_da_stringa = "#{params[:da]['data(2i)'].blank? ? 1 : params[:da]['data(2i)']}/#{params[:da]['data(3i)'].blank? ? 1 : params[:da]['data(3i)']}/#{params[:da]['data(1i)'].blank? ? Time.now.year : params[:da]['data(1i)'] }"
      if stringa_per_data_valida?(data_da_stringa)
        @data_da = data_da_stringa.to_date
      else
        @data_da = nil
      end
    end
    unless (params[:a].nil? || (params[:a]['data(2i)']+params[:a]['data(3i)']+params[:a]['data(1i)']).blank?)
      data_a_stringa = "#{params[:a]['data(2i)'].blank? ? 1 : params[:a]['data(2i)']}/#{params[:a]['data(3i)'].blank? ? 1 : params[:a]['data(3i)']}/#{params[:a]['data(1i)'].blank? ? Time.now.year : params[:a]['data(1i)'] }"
      if stringa_per_data_valida?(data_a_stringa)
        @data_a = data_a_stringa.to_date
      else
        @data_a = nil
      end
    end

    ## aggiusto casi di date mancanti
    @data_a = Time.now.to_date if (@data_a.nil?  && !@data_da.nil?)
    @data_da = nil             if (@data_da.nil? && !@data_a.nil?)



    if request.method == :get
      @fatture = Array.new
    else
      # request.method == :post
      @fatture = Fattura.find(:all,
                                              :conditions =>  conditions,
                                              :order => 'data_emissione DESC')
      ###
      # cancella fatture che non hanno data campione rispondente alle richieste
      if !@data_da.nil? && !@data_a.nil?
        # conditions += " AND updated_at > '#{@data_da.strftime("%Y-%m-%d 00:00:00")}' AND updated_at < '#{@data_a.strftime("%Y-%m-%d 23:59:59")}'"
        @fatture.delete_if{|fattura| fattura.data_emissione < @data_da || fattura.data_emissione > @data_a}
        flash[:notice] = "Elenco fatture con data emissione dal #{@data_da.strftime("%d-%m-%Y")} al  #{@data_a.strftime("%d-%m-%Y")}"
      elsif !giorni.blank?
        search_date =  (Time.now - (60*60*24*giorni.to_i)).to_date
        #search_date = (Time.now - (60*60*24*giorni.to_i)).strftime("%Y-%m-%d 00:00:00")
        @fatture.delete_if{|fattura| fattura.data_emissione < search_date }
        flash[:notice] = "Elenco fatture con data emissione di #{giorni} giorni fa"
        #conditions += " AND updated_at > '#{search_date}'"
      end
      ###
      unless cliente_id.blank?
        @fatture.delete_if { |fattura| fattura.cliente.id !=  cliente_id.to_i }
      end
      ## fattura da pagare?
      if da_pagare == 'si'
        @fatture.delete_if{|fattura| fattura.pagata? }
      elsif da_pagare == 'no'
        @fatture.delete_if{|fattura| !fattura.pagata? }
      end


      @fatture.each do |fattura|
        @sommatoria_prezzo_totale += fattura.totale
      end
      @fatture_da_mostrare = @fatture.map{|fattura| fattura.id}
      if @fatture.empty?
        flash[:notice] = "nessun risultato"
      end
    end
  end

  
  def dati_rapporto
    @rapporto = Rapporto.find(params[:id])
    if params[:azione] == 'ricalcola'
      @rapporto.calcola
      @rapporto.reload
      flash[:notice] = 'Rapporto ricalcolato'
    end
    if params[:azione] == 'attualizza_prezzo'
      @rapporto.attualizza_prezzo
      flash[:notice] = 'Prezzo aggiornato con i valori attuali'
    end
    # rapporto.prove[0].variabili    sono le variabili che devo visualizzare del rapporto
    variabili_da_visualizzare = @rapporto.prove_totali.map {|prova| prova.variabili}.flatten.uniq
      @variabile_rapporto_items = @rapporto.variabile_rapporto_items.clone # clone necessario, altrimenti con i delete MODIFICO @rapporto (anche se non lo salvo)
    case params[:filtro]
    when 'solo_dati_visualizzati'
      unless @variabile_rapporto_items.nil?
        @variabile_rapporto_items.delete_if { |variabile_rapporto_item| !variabili_da_visualizzare.include? variabile_rapporto_item.variabile }
      end
    when 'solo_dati_input'
      unless @variabile_rapporto_items.nil?
        @variabile_rapporto_items.delete_if { |variabile_rapporto_item| variabile_rapporto_item.variabile.tipo == 'funzione' }
      end
    when 'solo_dati_mancanti'
      unless @variabile_rapporto_items.nil?
        @variabile_rapporto_items.delete_if { |variabile_rapporto_item| !variabile_rapporto_item.manca? }
      end
    when 'solo_funzioni'
      unless @variabile_rapporto_items.nil?
        @variabile_rapporto_items.delete_if { |variabile_rapporto_item| variabile_rapporto_item.variabile.tipo != 'funzione' }
      end
    end
    @variabile_rapporto_items.reverse!
    # disabilito l'ordinamento per simbolo
    #@variabile_rapporto_items = @variabile_rapporto_items.sort_by {|variabile_rapporto_items| variabile_rapporto_items.variabile.simbolo}
  end
  
  def _dati_rapporto_variabile_ajax_form
    @variabile_rapporto_item = VariabileRapportoItem.find(params[:id])
    if @variabile_rapporto_item.variabile.tipo == 'input-testo'
      @variabile_rapporto_item.valore_testo  = params[:valore]
    else
      @variabile_rapporto_item.valore_numero = params[:valore]
    end
    if @variabile_rapporto_item.save
      @variabile_rapporto_item.rapporto.calcola
      # flash[:notice] = 'Dato Aggiornato, e rapporto ricalcolato'
      # TODO nella seguente esegui il ricalcolo solo quando necessario
      #@variabile_rapporto_item.rapporto.calcola
    else
      # ripristino i valori prima del salvataggio
      @variabile_rapporto_item.reload
      #flash[:error] = 'Errore!'
    end
    render :layout => false
  end

  def _dati_rapporto_incertezza_di_misura_ajax_form
    @variabile_rapporto_item = VariabileRapportoItem.find(params[:id])
    @variabile_rapporto_item.incertezza_di_misura = params[:incertezza_di_misura]
    if @variabile_rapporto_item.save
    else
      #flash[:error] = 'Errore!'
    end
    render :layout => false
  end

  def duplica_rapporto
    rapporto_originale = Rapporto.find(params[:id])
    rapporto_nuovo = crea_e_restituisci_duplicato_del_rapporto_su_campione(params[:id], nil)
    if rapporto_nuovo.nil?
      # il flash con l'errore è stato già popolato
      redirect_to :controller => :rapporti
    else
      flash[:error] =  "Duplicato di rapporto #{('n. '+rapporto_originale.numero.to_s) unless rapporto_originale.numero.nil? } #{'anno '+rapporto_originale.anno.to_s unless rapporto_originale.anno.nil?} creato correttamente"
      redirect_to :action => :dati_rapporto, :id => rapporto_nuovo.id
    end
  end

  def duplica_campione
    campione_originale = Campione.find(params[:id])
    if campione_originale.nil?
      flash[:error] = 'Errore: stai tentando di duplicare un campione inesistente'
    else
      # faccio il clone, ma faccio ATTENZIONE altrienti rischio in futuro di portarmi appresso valori che non controllo
      campione_nuovo = campione_originale.clone
      # calcolo il numero del campione
      campioni_anno_in_corso = Campione.find(:all, :order => "numero DESC", :conditions => "numero IS NOT NULL AND anno = #{DateTime.now.year}")
      ultimo_campione = campioni_anno_in_corso[0]
      if ultimo_campione.nil?
        # tengo conto del caso in cui non ci siano campioni
        prossimo_numero_libero = 1
        # Non ci sono campioni presenti per l'anno in corso, iniziare dunque con il n. 1
      else
        prossimo_numero_libero = ultimo_campione.numero+1
      end
      campione_nuovo.numero = prossimo_numero_libero
      campione_nuovo.anno = DateTime.now.year
      campione_nuovo.data = DateTime.now
      #campione_nuovo.note = "< DUPLICATO DI CAMPIONE #{('n. '+campione_originale.numero.to_s) unless campione_originale.numero.nil? } #{'anno '+campione_originale.anno.to_s unless campione_originale.anno.nil?} > #{campione_originale.note}"
      # Salvo
      if campione_nuovo.save
        # il campione è salvato, ora devo duplicare i rapporti
        rapporti_creati = 0
        campione_originale.rapporti.each do |rapporto_originale|
          rapporto_nuovo =  crea_e_restituisci_duplicato_del_rapporto_su_campione(rapporto_originale.id, campione_nuovo.id)
          if rapporto_nuovo.nil?
            # il flash con l'errore è stato già popolato
            flash[:error] = flash[:error].to_s+ "Duplicato di rapporto #{('n. '+rapporto_originale.numero.to_s) unless rapporto_originale.numero.nil? } #{'anno '+rapporto_originale.anno.to_s unless rapporto_originale.anno.nil?} non creato. Avvertire Francesco"
            return
          else
            rapporti_creati += 1
          end
        end
        flash[:notice] =  "Duplicato di campione #{('n. '+campione_originale.numero.to_s) unless campione_originale.numero.nil? } #{'anno '+campione_originale.anno.to_s unless campione_originale.anno.nil?} creato correttamente (con nuovo n. RC = #{campione_nuovo.numero})"
        if rapporti_creati > 0
          flash[:notice] += " e con successo ho creato #{rapporti_creati} rapporto/i" unless rapporti_creati == 0
          # giusy preferisce il redirect sulla modifica del campione
          # redirect_to "/campioni/#{campione_nuovo.id}/nested?_method=get&associations=rapporti"

        else
          #giusy preferisce il redirect sulla modifica del campione
          #redirect_to :controller => :campioni, :action => :show, :id => campione_nuovo.id
        end
        redirect_to :controller => :campioni, :action => :edit, :id => campione_nuovo.id
      else
        flash[:error] = 'Errore: non riesco a salvarare il campione clonato. Avvertire Francesco'
        redirect_to :controller => :campioni
      end
    end
  end

#  def controlla_prova_variabile_item
#    @errore = ''
#    @numero = 0
#    ProvaVariabileItem.all.each do |record|
#      @errore+= "<br />errore su variabile_prova_item_id #{record}<br />" if record.prova.matrice != record.variabile.matrice
#      @numero +=1
#    end
#    render :test
#  end
#
#  def controlla_prova_tipologia_item
#    @errore = ''
#    @numero = 0
#    ProvaTipologiaItem.all.each do |record|
#      @errore+= "<br />errore su variabile_prova_item_id #{record}<br />" if record.prova.matrice != record.tipologia.matrice
#      @numero +=1
#    end
#    render :test
#  end
#  def assegna_anni
#    @rapporti = Rapporto.all
#    @rapporti.each do |rapporto|
#      rapporto.update_attributes({:anno => Time.now.year})
#    end
#    @rapporti_errati = Rapporto.find(:all, :conditions => "anno != 2010")
#    #Campione
#    @campioni = Campione.all
#    @campioni.each do |campione|
#      campione.update_attributes({:anno => campione.data.year})
#    end
#    @campioni_errati = Campione.find(:all, :conditions => "anno != 2010")
#  end

def utilita
  unless current_user.is_admin?
    flash[:error] = "pagina accessibile solo agli amministratori"
    redirect_to :controller => :admin
  end
end

def attualizza_prezzi
  numero_iniziale = params[:numero_iniziale].to_i
  numero_finale   = params[:numero_finale].to_i
  anno = params[:anno]
  if params[:numero_iniziale].blank? ||
     params[:numero_finale].blank? ||
     params[:anno].blank? ||
     numero_iniziale < 0 ||
     numero_finale < 0 ||
     numero_finale < numero_iniziale
       flash[:error] =  "Errore: hai inserito dei valori non coerenti"
            redirect_to :action => :utilita
  else
     condizioni = "anno=#{anno} AND numero >= #{numero_iniziale} AND numero <= #{numero_finale}"
     rapporti_da_aggiornare = Rapporto.find(:all,
                                              :conditions =>  condizioni)
     numero_aggiornamenti=0
     rapporti_da_aggiornare.each  do |rapporto|       
       numero_aggiornamenti += 1 if rapporto.attualizza_prezzo
     end
     if rapporti_da_aggiornare.size == 0
       flash[:notice] =  "Non ci sono rapporti con Rdp compreso tra il n.#{numero_iniziale} ed il n.#{numero_finale} nell'anno #{anno}."
     elsif numero_aggiornamenti > 0
       flash[:notice] =  "Aggiornamento eseguito! <br/>I prezzi di <b>#{numero_aggiornamenti}</b> rapporti (su un totale di #{rapporti_da_aggiornare.size} rapporti estratti: dall'Rdp n.#{numero_iniziale} al n.#{numero_finale} dell'anno #{anno}) sono stati aggiornati secondo il listino prezzi attuale."
     else
       flash[:notice] =  "Nessun Aggiornamento eseguito: non ci sono rapporti che necessitano di aggiornamento nel totale di #{rapporti_da_aggiornare.size} rapporti estratti (dall'Rdp n.#{numero_iniziale} al n.#{numero_finale} dell'annno #{anno})."
     end
     redirect_to :action => :utilita
  end
end

#def attualizza_tutti_i_prezzi
#  #@numero = 0
#  Rapporto.all.each do |rapporto|
#    rapporto.attualizza_prezzo
#    #@numero += 1
#  end
#  flash[:notice] =  "Tutti i prezzi delle analisi effettuate sono stati aggiornati secondo il listino prezzi attuale"
#  redirect_to :action => :index
#end

 def dati_fattura
    @fattura = Fattura.find(params[:id])
#    if params[:azione] == 'ricalcola'
#      @fattura.calcola
#      @fattura.reload
#      flash[:notice] = 'Fattura ricalcolato'
#    end
#    if params[:azione] == 'attualizza_prezzo'
#      @fattura.attualizza_prezzo
#      flash[:notice] = 'Prezzo aggiornato con i valori attuali'
#    end
    # aggiornamento prezzi
    nuovo_prezzo = params[:prezzo].to_f
    if params[:prezzo]
        if params[:tipologia_id]
          # aggiorno il prezzo dei rapporti di quella tipologia
          tipologia_da_aggiornare = Tipologia.find(params[:tipologia_id].to_i)
          # controllo
          #if nuovo_prezzo.class
          @fattura.aggiorna_il_prezzo_della_tipologia(tipologia_da_aggiornare,nuovo_prezzo)
        end
        if params[:auto_prova_id]
          #aggiorno il prezzo delle autoprove  di questa fattura
          auto_prova_da_aggiornare = Prova.find(params[:auto_prova_id].to_i)
          @fattura.aggiorna_il_prezzo_della_auto_prova(auto_prova_da_aggiornare,nuovo_prezzo)
        end
        if params[:prova_id]
          #aggiorno il prezzo delle prove aggiuntive di questa prova
          prova_aggiuntiva_da_aggiornare = Prova.find(params[:prova_id].to_i)
          @fattura.aggiorna_il_prezzo_della_prova(prova_aggiuntiva_da_aggiornare,nuovo_prezzo)
        end
      flash[:notice] = 'Prezzo aggiornato. Ricordati di rigenerare il pdf.'
    end
    if params[:percentuale_sconto]
      @fattura.update_attribute(:percentuale_sconto, params[:percentuale_sconto].to_f)
      flash[:notice] = 'Sconto aggiornato. Ricordati di rigenerare il pdf.'
    end
  end

  def listino
    #
    unless current_user.is_admin?
      flash[:error] = "pagina accessibile solo agli amministratori"
      redirect_to :controller => :admin
    end
    #
    @anno = params[:anno].to_i
    @anno = Time.now.year if @anno == 0

    nuovo_prezzo = params[:prezzo].to_f
    if params[:prezzo] && nuovo_prezzo >= 0
      if params[:tipologia_id]
        tipologia = Tipologia.find_by_id(params[:tipologia_id])
        # senza validazione
        tipologia.update_attribute(:prezzo, nuovo_prezzo)
      end

      if params[:prova_id]
        prova = Prova.find_by_id(params[:prova_id])
        # senza validazione
        prova.update_attribute(:prezzo, nuovo_prezzo)
      end
      flash[:notice] = 'Prezzo aggiornato'

    end
    # TIPOLOGIE
    # prendo solo le tipologie a forfeit
    @tipologie_a_forfeit = Tipologia.find(:all,:conditions => {:forfeit => true})
    @tipologie_a_forfeit.uniq!
    # conteggio tipologie
    # Hash con {tipologia_id => [contatore_tipologie_FATTURATE, contatore_tipologie_da_fatturare}
    @numero_tipologie = Hash.new
    # inizializzo
    Tipologia.all.uniq.each {|tipologia| @numero_tipologie[tipologia.id]=[0,0] }
#    @rapporti = Rapporto.find(:all, :conditions => {:anno => @anno})
#    @rapporti.each do |rapporto|
#      if rapporto.tipologia.forfeit
#        if rapporto.fattura
#          @numero_tipologie[rapporto.tipologia.id][0] += 1
#        else
#          @numero_tipologie[rapporto.tipologia.id][1] += 1
#        end
#      end
#    end

    # PROVE
    # prove delle tipologie non a forfeit
    prove_delle_tipologie_non_a_forfeit = Tipologia.find(:all,:conditions => {:forfeit => false}).map{|tipologia| tipologia.prove}
    # prove aggiuntive (prendo solo quelle che sono utilizzate)
    prove_aggiuntive = ProvaRapportoItem.all.map{|prova_rapporto_item| prova_rapporto_item.prova }
    # prove_totali_uniche
    @prove = (prove_delle_tipologie_non_a_forfeit + prove_aggiuntive)
    @prove.uniq!
    @prove = Prova.all.uniq
    #
    # conteggio prove
    # Hash con {prove_id => [contatore_prove_FATTURATE, contatore_prove_da_fatturare}
    @numero_prove = Hash.new
    # inizializzo
    Prova.all.uniq.each {|prova| @numero_prove[prova.id]=[0,0] }
#    @rapporti = Rapporto.find(:all, :conditions => {:anno => @anno})
#    @rapporti.each do |rapporto|
#      if !rapporto.tipologia.forfeit
#        if rapporto.fattura
#          rapporto.prove.each{|prova| @numero_prove[prova.id][0] += 1}
#          rapporto.prova_rapporto_items.each{|prova_rapporto_item| @numero_prove[prova_rapporto_item.prova.id][0] += 1}
#        else
#          rapporto.prove.each{|prova| @numero_prove[prova.id][1] += 1}
#          rapporto.prova_rapporto_items.each{|prova_rapporto_item| @numero_prove[prova_rapporto_item.prova.id][1] += 1}
#        end
#      end
#    end

    # controllo
    @prezzo_totale_tutti_rapporti = 0
#    Rapporto.find(:all, :conditions => {:anno => @anno}).each do |rapporto|
##      @prezzo_totale_tutti_rapporti += rapporto.prezzo_totale
#    end

    # esegue gli effettivi conteggi
    Rapporto.find(:all, :conditions => {:anno => @anno}).each do |rapporto|
      # TIPOLOGIE
      if rapporto.tipologia.forfeit
        if rapporto.fattura
          @numero_tipologie[rapporto.tipologia.id][0] += 1
        else
          @numero_tipologie[rapporto.tipologia.id][1] += 1
        end
      # PROVE
      else 
        if rapporto.fattura
          rapporto.tipologia.prove.each{|prova| @numero_prove[prova.id][0] += 1}
          rapporto.prova_rapporto_items.each{|prova_rapporto_item| @numero_prove[prova_rapporto_item.prova.id][0] += 1}
        else
          rapporto.tipologia.prove.each{|prova| @numero_prove[prova.id][1] += 1}
          rapporto.prova_rapporto_items.each{|prova_rapporto_item| @numero_prove[prova_rapporto_item.prova.id][1] += 1}
        end
      end
      # TOTALE
      @prezzo_totale_tutti_rapporti += rapporto.prezzo_totale
    end
  end

end
