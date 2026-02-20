class RapportiController < ApplicationController

  layout 'admin'
  before_filter :require_admin_or_operator
  
  require 'fileutils'


  active_scaffold :rapporto do |config|
    #columns[:numero].description = "(numero Rdp)"
    #columns[:data].description = "(compare nel rapporto di prova)"
    columns[:data_scadenza].description = "lascia in bianco per rapporti senza una scadenza specifica"
    columns[:data_esecuzione_prove_fine].description = "lascia in bianco per prove eseguite in un unico giorno"
    columns[:note].description = "note interne (non visibili ai clienti)"
    columns[:pie_pagina].description = "il testo che verrà stampato nelle note sul rapporto di prova (HTML ammesso): <br/> a capo"
    # la seguente viene usata per l'ordinamento quando si clicca sulla colonna Rdp, 
    # quando vi si riclicca, activescaffold aggiunge un DESC alla fine
    columns[:numero].sort_by :sql => 'anno ASC, numero'
    columns = [
                :dati_rapporto_link,
                :stampa_dati_link,
                :stampa_rapporto_link,
                :duplica_rapporto_link,
                :fattura_link,
                :status,
                :tipologia,
                :campione,
                :prova_rapporto_items,
                :numero,
                :anno,
                :numero_supplemento,
                :data_richiesta,
                :data_scadenza,
                :note,
                :prezzo_totale,
                :data_invio_email,
                :data_invio_sms,
                #:prove,
                #:variabile_rapporto_items,
                #:variabili,
                :data_esecuzione_prove_inizio,
                :data_esecuzione_prove_fine,
                :data_stampa,
                :pie_pagina,
                #:fattura,
               ]
    config.columns = 	columns
    config.list.columns = columns - [:note] - [:data_esecuzione_prove_fine]-[:pie_pagina]-[:data_esecuzione_prove_inizio]-[:data_stampa]
    config.columns[:prova_rapporto_items].label = "Prove aggiuntive"
    config.create.columns.exclude  :fattura_link, :status, :prezzo_totale, :data_invio_email, :data_invio_sms, :variabile_rapporto_items, :prova_rapporto_items
    config.create.columns.exclude  :variabile_rapporto_items, :prova_rapporto_items, :dati_rapporto_link,  :stampa_rapporto_link, :stampa_dati_link, :duplica_rapporto_link
    config.update.columns.exclude  :fattura_link, :prezzo_totale, :variabile_rapporto_items, :status, :dati_rapporto_link,  :stampa_rapporto_link, :stampa_dati_link, :duplica_rapporto_link #, :data_invio_email, :data_invio_sms
    config.subform.columns.exclude :fattura_link, :prezzo_totale, :variabile_rapporto_items, :data_invio_email, :data_invio_sms, :status, :dati_rapporto_link, :stampa_rapporto_link,  :stampa_dati_link, :duplica_rapporto_link
#    config.update.columns.exclude  :variabili, :prove, :variabile_rapporto_items,:prova_rapporto_items
#    #config.columns[:campioni].form_ui = :select
#    list.sorting = {:campione_id => :asc}
    config.columns[:tipologia].form_ui = :select
    config.columns[:campione].form_ui = :select
    config.columns[:tipologia].set_link('nested', :parameters => nil)
    config.columns[:prova_rapporto_items].set_link('nested', :parameters => nil)
    #config.columns[:prova_rapporto_items].set_link('nested', :parameters => {:associations => :prova_rapporto_items})
    #config.subform.columns.exclude :numero, :data, :note, :prezzo, :variabile_rapporto_items, :prova_rapporto_items
    #config.action_links.add 'get_pdf', :label => 'Download PDF'
    config.columns[:numero].label = 'Rdp n.'
    config.columns[:anno].label = 'Rdp anno'
    config.columns[:note].label = "Note interne"
    config.columns[:pie_pagina].label = "Pié pagina"
    config.columns[:duplica_rapporto_link].label = 'Dup'
    config.columns[:dati_rapporto_link].label = 'Dati Rapporto'
    config.columns[:stampa_dati_link].label = 'Anteprima'
    config.columns[:stampa_rapporto_link].label = 'Rapporto'
    config.columns[:fattura_link].label = 'Fattura'
    config.columns[:data_esecuzione_prove_inizio].label = 'Data esec. prove dal:'
    config.columns[:data_esecuzione_prove_fine].label = ' al:'
    config.columns[:numero_supplemento].label = 'Suppl. n.'
    list.sorting =  { :data_richiesta => :desc }
    list.per_page = 50
    # ricerca - aggiungo numero
    # nota... devo aggiungere `rapporti`. per evitare ambiguità
    config.columns[:numero].search_sql = '`rapporti`.numero'
    config.search.columns << :numero
    #
    config.theme = :blue
  end

  def conditions_for_collection
    # ['user_type IN (?)', ['admin', 'sysop']]
    if params[:cliente_id]
      cliente = Cliente.find_by_id(params[:cliente_id].to_i)
      if cliente.nil?
        flash[:error] = 'Attenzione, stai filtrando i rapporti su un cliente inesistente'
        return false
      else
        if params[:campione_anno].nil?
          flash[:notice] = "(filtrato) Elenco rapporti cliente: <strong>#{cliente.nome}</strong>"
          campioni_da_mostrare = cliente.campioni.map {|campione| campione.id if !campione.rapporti.nil?}
        else
          flash[:notice] = "(filtrato) Elenco rapporti cliente: <strong>#{cliente.nome}</strong> per campioni con RC anno: <strong>#{params[:campione_anno]}</strong>"
          campioni_da_mostrare = cliente.campioni.map {|campione| campione.id if (!campione.rapporti.nil? && campione.anno == params[:campione_anno].to_i)}
        end
#        if params[:rapporto_anno].nil?
#          ['campione_id IN (?)', campioni_da_mostrare]
#        else
#          #['campione_id IN (?) AND campione.anno = ?', campioni_da_mostrare, 2008]
#          #"user_name = '#{user_name}' AND password = '#{password}'"
#          # attenzione, devo mettere `rapporti` per evitare disambiguita
#          "campione_id IN (#{campioni_da_mostrare.map{|campione| campione.id}}) AND `rapporti`.anno = #{params[:anno].to_i}"
#        end
        ['campione_id IN (?)', campioni_da_mostrare]
      end
    end
  end

  # nb, per un elenco personalizzato fai delle chiamate
  # es http://localhost:3000/rapporti/update_table?page=1&sort=campione&sort_direction=ASC

  def da_completare
    # rapporti con status in lavorazione
  end

  def stampa_dati
    @rapporto = Rapporto.find(params[:id])
    @variabile_rapporto_items = @rapporto.variabile_rapporto_items.clone # clone necessario, altrimenti con i delete MODIFICO @rapporto (anche se non lo salvo)
    @variabile_rapporto_items_solo_funzioni = @variabile_rapporto_items.clone # clone necessario, altrimenti con i delete MODIFICO @rapporto (anche se non lo salvo)
    # Estrai le sole funzioni
    @variabile_rapporto_items_solo_funzioni.delete_if { |variabile_rapporto_item| variabile_rapporto_item.variabile.tipo != 'funzione' }
    @variabile_rapporto_items_ordinate = []
    @variabile_rapporto_items.each do |variabile_rapporto_item|
      @variabile_rapporto_items_ordinate << variabile_rapporto_item
      variabile_rapporto_item.variabile.variabili_indipendenti.each do |variabile|
        @variabile_rapporto_items.each {|variabile_rapporto_item| (@variabile_rapporto_items_ordinate << variabile_rapporto_item) if (variabile_rapporto_item.variabile.id == variabile.id) }
      end
    end

    @prove_totali = @rapporto.prove_totali_ordinate.clone
    render :layout => 'layout_vuoto'
  end

  def stampa_dati_di_tutti_i_rapporti
    @rapporti_non_pronti = Rapporto.find(:all,
                                            # originale
                                            #:conditions =>  "(status = '#{RAPPORTO_STATUS_DEFAULT}' OR numero IS NULL)",
                                            # modificata per escludere rapporti 2010 modificati nel tempo
                                            #:conditions =>  "(status = '#{RAPPORTO_STATUS_DEFAULT}' OR numero IS NULL) AND NOT (anno!=2010 AND numero<94)",
                                            :conditions =>  "(status = '#{RAPPORTO_STATUS_DEFAULT}' OR numero IS NULL) AND NOT (anno=2010 AND ((numero IS NOT NULL) AND numero<=1034))",

                                            :order => 'data_scadenza, created_at DESC')
    render :layout => 'layout_vuoto'
  end

  def rdp
    # la seguente per stampa modello vuoto
    # http://localhost:3000/rapporti/rdp/903?format=pdf&stampa_modello_vuoto=1
    if params[:stampa_modello_vuoto]=='1'
      @style_nascosto_se_stampa_modello_vuoto = ' visibility:hidden; '
    else
      @style_nascosto_se_stampa_modello_vuoto = ' visibility:visible; '
    end
    #
    @rapporto = Rapporto.find(params[:id])
#    if !@rapporto.variabili_tutte_inserite?
#      flash[:error] = 'Il rapporto non è completo, mancano dei dati.'
#      redirect_to :controller => :admin, :action => :dati_rapporto, :id => @rapporto.id
#    elsif @rapporto.numero.nil?
#      flash[:error] = 'Numero Rdp mancante'
#      redirect_to :controller => :rapporti, :action => :edit, :id => @rapporto.id
#    elsif @rapporto.data_esecuzione_prove_inizio.nil?
#      flash[:error] = 'Data esecuzione prove mancante'
#      redirect_to :controller => :rapporti, :action => :edit, :id => @rapporto.id
#    else
      # ok, ready to generate pdf
      @rapporto.aggiorna_data_di_stampa_se_mancante
      @variabile_rapporto_items = @rapporto.variabile_rapporto_items.clone
      @prove_totali = @rapporto.prove_totali_ordinate.clone
      #
      # tento la creazione del file

      # non genero il render se arrivo da 'invia_email'
      unless  @codice_senza_render
        # visualizza_rapporto
        respond_to do |format|
          format.html {render :layout => 'rdp'}
          format.pdf do
            # default are
            # layout:      false
            # template:    the template for the current controller/action
            # stylesheets: none
            render :pdf => "rdp", :stylesheets => ["rdp", "prince"], :layout => "rdp"
          end
        end
      end
#    end
  end

  def crea_pdf
    # il presente genera il file pdf, e.. .qualora presente, gli scrive sopra
    begin
      rapporto = Rapporto.find(params[:id])
      
      # Validazioni
      if !rapporto.variabili_tutte_inserite?
        flash[:error] = 'Il rapporto non è completo, mancano dei dati.'
        redirect_to :controller => :admin, :action => :dati_rapporto, :id => rapporto.id
        return
      elsif rapporto.numero.nil?
        flash[:error] = 'Numero Rdp mancante'
        redirect_to :controller => :rapporti, :action => :edit, :id => rapporto.id
        return
      elsif rapporto.data_esecuzione_prove_inizio.nil?
        flash[:error] = 'Data esecuzione prove mancante'
        redirect_to :controller => :rapporti, :action => :edit, :id => rapporto.id
        return
      end
      
      # Verifica che la directory PDF esista
      pdf_dir = File.dirname(rapporto.nome_file_pdf_del_rapporto_con_path_assoluto)
      unless File.directory?(pdf_dir)
        FileUtils.mkdir_p(pdf_dir)
        logger.info "Creata directory PDF: #{pdf_dir}"
      end
      
      # Se presente, elimina il PDF esistente (con backup automatico)
      rapporto.pdf_elimina if rapporto.pdf_esiste?
      
      # Genera il PDF
      @codice_senza_render = true
      rdp
      
      begin
        rdp_pdf = make_pdf(:template => "rapporti/rdp.erb", :pdf => "rdp", :stylesheets => ["rdp", "prince"], :layout => "rdp")
        
        if rdp_pdf.nil? || rdp_pdf.empty? || !rdp_pdf.start_with?("%PDF")
          raise "PDF generato non valido o vuoto"
        end
        
        # Salva il file PDF
        nome_file = rapporto.nome_file_pdf_del_rapporto_con_path_assoluto
        File.open(nome_file, 'wb') do |f|
          f.write(rdp_pdf)
        end
        
        # Verifica che il file sia stato creato correttamente
        unless File.exist?(nome_file) && File.size(nome_file) > 100
          raise "File PDF non creato correttamente o troppo piccolo"
        end
        
        flash[:notice] = 'PDF creato con successo'
        logger.info "PDF creato con successo per rapporto #{rapporto.numero}/#{rapporto.anno}: #{nome_file}"
        
      rescue => e
        logger.error "Errore durante la generazione PDF per rapporto #{rapporto.id}: #{e.message}"
        logger.error e.backtrace.join("\n")
        flash[:error] = "Errore durante la generazione del PDF: #{e.message}"
        redirect_to :controller => :admin, :action => :dati_rapporto, :id => rapporto.id
        return
      end
      
      redirect_to :controller => :admin, :action => :dati_rapporto, :id => rapporto.id
      
    rescue => e
      logger.error "Errore generale in crea_pdf per rapporto #{params[:id]}: #{e.message}"
      logger.error e.backtrace.join("\n")
      flash[:error] = "Errore durante la generazione del PDF: #{e.message}"
      redirect_to :controller => :admin, :action => :dati_rapporto, :id => params[:id]
    end
  end

  def mostra_pdf
    rapporto = Rapporto.find(params[:id])
    nome_file = rapporto.nome_file_pdf_del_rapporto_con_path_assoluto
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
      raise "Errore: stai tentando di visualizzare un PDF inesistente (rapporto n.#{rapporto.numero}, id=#{rapporto.id}). Avvertire Francesco"
    end
  end

  # ============================================================================
  # NUOVO METODO PDF DIRETTO - FUNZIONA SUBITO SENZA CAZZATE!
  # ============================================================================
  def anteprima_risultati_pdf_diretto
    if params[:rapporty_array].nil? || params[:rapporty_array].empty?
      flash[:error] = "Non hai selezionato alcun rapporto"
      redirect_to :controller => :admin, :action => :cerca_rapporti
      return
    end
    
    begin
      # Carica i rapporti
      @rapporti = params[:rapporty_array].map{|rapporto_id| Rapporto.find_by_id(rapporto_id.to_i)}.compact
      
      if @rapporti.empty?
        flash[:error] = "Nessun rapporto valido selezionato"
        redirect_to :controller => :admin, :action => :cerca_rapporti
        return
      end
      
      # Ordina per numero
      @rapporti.sort! {|x,y| (y.numero||0) <=> (x.numero||0) }
      
      # Calcola variabili da mostrare
      @variabili = []
      @rapporti.each do |rapporto|
        rapporto.variabile_rapporto_items.each do |variabile_rapporto_item|
          @variabili << variabile_rapporto_item.variabile unless @variabili.include?(variabile_rapporto_item.variabile)
        end
      end
      @variabili.sort! {|x,y| (x.posizione_in_rdp||999) <=> (y.posizione_in_rdp||999) }
      
      # Prepara tabella dati
      @tabella = []
      riga = 1
      @rapporti.each do |rapporto|
        @tabella[riga] = Hash.new
        rapporto.variabile_rapporto_items.each do |variabile_rapporto_item|
          @tabella[riga][variabile_rapporto_item.variabile.id] = variabile_rapporto_item.valore_automatico
        end
        riga += 1
      end
      
      # Genera HTML pulito
      html_content = render_to_string(
        :template => 'rapporti/anteprima_risultati_pdf_diretto.erb',
        :layout => false
      )
      
      # GENERA PDF DIRETTAMENTE CON WKHTMLTOPDF - NIENTE CAZZATE!
      temp_html_file = "/tmp/anteprima_#{Time.now.to_i}.html"
      temp_pdf_file = "/tmp/anteprima_#{Time.now.to_i}.pdf"
      
      # Scrivi HTML temporaneo
      File.open(temp_html_file, 'w') { |f| f.write(html_content) }
      
      # COMANDO WKHTMLTOPDF DIRETTO
      wkhtmltopdf_cmd = [
        'xvfb-run', '-a', 'wkhtmltopdf',
        '--page-size', 'A4',
        '--orientation', 'Landscape',
        '--margin-top', '15mm',
        '--margin-right', '10mm', 
        '--margin-bottom', '15mm',
        '--margin-left', '10mm',
        '--encoding', 'UTF-8',
        '--disable-smart-shrinking',
        '--print-media-type',
        '--quiet',
        temp_html_file,
        temp_pdf_file
      ]
      
      # ESEGUI COMANDO
      system(*wkhtmltopdf_cmd)
      
      if File.exist?(temp_pdf_file) && File.size(temp_pdf_file) > 500
        # PDF GENERATO CON SUCCESSO!
        pdf_data = File.read(temp_pdf_file)
        
        # Pulisci file temporanei
        File.delete(temp_html_file) if File.exist?(temp_html_file)
        File.delete(temp_pdf_file) if File.exist?(temp_pdf_file)
        
        # INVIA PDF AL BROWSER
        send_data(pdf_data,
          :filename => "anteprima_risultati_#{Date.today.strftime('%Y%m%d')}.pdf",
          :type => 'application/pdf',
          :disposition => 'inline'
        )
        return
        
      else
        # PDF fallito
        logger.error "ERRORE: PDF non generato o vuoto"
        flash[:error] = "Errore nella generazione del PDF"
        redirect_to :controller => :admin, :action => :cerca_rapporti
        return
      end
      
    rescue => e
      logger.error "ERRORE PDF DIRETTO: #{e.message}"
      logger.error e.backtrace.join("\n")
      flash[:error] = "Errore nella generazione del PDF: #{e.message}"
      redirect_to :controller => :admin, :action => :cerca_rapporti
    end
  end

  def anteprima_risultati
    if params[:rapporty_array].nil? || params[:rapporty_array].empty?
      if params[:format] == 'pdf'
        render :text => "Errore: Non hai selezionato alcun rapporto", :status => 400
        return
      else
        flash[:error] = "Non hai selezionato alcun rapporto"
        redirect_to :controller => :admin, :action => :cerca_rapporti
        return
      end
    else
      begin
        @rapporti = params[:rapporty_array].map{|rapporto_id| Rapporto.find_by_id(rapporto_id.to_i)}.compact
        
        # Se non ci sono rapporti validi, mostra un errore
        if @rapporti.empty?
          if params[:format] == 'pdf'
            render :text => "Errore: Nessun rapporto valido selezionato", :status => 400
            return
          else
            flash[:error] = "Nessun rapporto valido selezionato"
            redirect_to :controller => :admin, :action => :cerca_rapporti
            return
          end
        end
        
        # ordino per numero di Rdp (mettendo per primi quelli che non lo hanno)
        @rapporti.sort! {|x,y| (y.numero||0) <=> (x.numero||0) }
        
        # calcolo le variabili da mostrare (le colonne) - USA variabile_rapporto_items per coerenza
        @variabili = []
        @rapporti.each do |rapporto|
          begin
            logger.info "ANTEPRIMA DEBUG: Elaborando rapporto ID #{rapporto.id}, numero #{rapporto.numero}"
            
            # Usa variabile_rapporto_items per ottenere le variabili, non le prove
            rapporto.variabile_rapporto_items.each do |variabile_rapporto_item|
              variabile = variabile_rapporto_item.variabile
              unless @variabili.include?(variabile)
                @variabili << variabile
                logger.info "ANTEPRIMA DEBUG: Aggiunta variabile #{variabile.id} - #{variabile.nome} (#{variabile.simbolo})"
              end
            end
            
          rescue => e
            logger.error "ANTEPRIMA DEBUG: Errore elaborando rapporto #{rapporto.id}: #{e.message}"
            logger.error "ANTEPRIMA DEBUG: #{e.backtrace.join("\n")}"
          end
        end
        # Ordina le variabili per posizione
        @variabili.sort! {|x,y| (x.posizione_in_rdp||999) <=> (y.posizione_in_rdp||999) }
        
        logger.info "ANTEPRIMA DEBUG: Totale variabili trovate: #{@variabili.size}"
        @variabili.each { |v| logger.info "ANTEPRIMA DEBUG: Variabile: #{v.id} - #{v.nome} (#{v.simbolo})" } unless @variabili.empty?
        
        # Se non ci sono variabili da mostrare, mostra un avviso
        if @variabili.empty?
          logger.warn "ANTEPRIMA RISULTATI: Nessuna variabile trovata per i rapporti #{params[:rapporty_array].join(', ')}"
          logger.warn "ANTEPRIMA RISULTATI: Possibili cause:"
          logger.warn "  - I rapporti non hanno prove associate"
          logger.warn "  - Le prove non hanno variabili definite"
          logger.warn "  - Errore nel caricamento delle relazioni database"
        end
        
        # Intestazione
        @tabella = []
        
        riga = 1
        @rapporti.each do |rapporto|
          @tabella[riga] = Hash.new
          begin
            rapporto.variabile_rapporto_items.each do |variabile_rapporto_item|
              @tabella[riga][variabile_rapporto_item.variabile.id] = variabile_rapporto_item.valore_automatico
            end
          rescue => e
            logger.error "Errore durante il caricamento dei valori del rapporto #{rapporto.id}: #{e.message}"
          end
          riga += 1
        end
        
        # non genero il render se arrivo da 'invia_email'
        unless @codice_senza_render
          # visualizza_rapporto
          respond_to do |format|
            format.html {render :layout => 'anteprima_risultati'}
            format.pdf do
              # default are
              # layout:      false
              # template:    the template for the current controller/action
              # stylesheets: none
              render :pdf => "anteprima_risultati", :stylesheets => ["anteprima_risultati", "prince"], :layout => "anteprima_risultati"
            end
          end
        end
      rescue => e
        logger.error "Errore in anteprima_risultati: #{e.message}"
        logger.error e.backtrace.join("\n")
        
        if params[:format] == 'pdf'
          # Per PDF, mostra un messaggio di errore invece di fare redirect
          render :text => "Errore durante la generazione del PDF: #{e.message}", :status => 500
        else
          flash[:error] = "Si è verificato un errore durante la generazione dell'anteprima. Si prega di riprovare."
          redirect_to :controller => :admin, :action => :cerca_rapporti
        end
      end
    end
  end




  def invia_email
    # se ho params[:id] si tratta di rapporto singolo
    # se ho arams[:commit] si tratta di rapporti multipli
    #
    # params[:commit] => 'Invio email' / 'Invio sms' (not nil)
    # params[:sms_array] => ["106", "107", "108"]
    # params[:email_array] => ["106", "107", "108"]
    #
    # Ora che faccio?
    # Se ha cliccato su 'email' vado alla pagina della generazione email, precompilo e preparo allegato

    if params[:id].nil?
      if params[:email_rdp_array].nil? && params[:email_anteprima_array].nil?
        flash[:error] = "Seleziona i rapporti ai quali vuoi inviare l'email"
        redirect_to :controller => :admin, :action => :cerca_rapporti
        return
      else
        @rapporti_email_rdp     =  params[:email_rdp_array].map{|rapporto_id| Rapporto.find_by_id(rapporto_id.to_i)} unless params[:email_rdp_array].nil?
        @rapporti_email_anteprima =  params[:email_anteprima_array].map{|rapporto_id| Rapporto.find_by_id(rapporto_id.to_i)} unless params[:email_anteprima_array].nil?

        @rapporti =  (@rapporti_email_rdp || []) +(@rapporti_email_anteprima || [])
        @rapporti.uniq!
      end
    else
      @rapporti = [Rapporto.find_by_id(params[:id])]
      @rapporto = @rapporti[0]
    end

    # controllo che abbia selezionato rapporti dello stesso cliente
    # se NON params[:cliente_id].nil? allora posso stare tranquillo, altrimenti controllo
    if params[:cliente_id].nil? && @rapporti.map{|rapporto| rapporto.campione.cliente.id}.uniq.size > 1
          flash[:error] = "Per inviare email su più di un rapporto devi selezionare solo rapporti dello stesso cliente"
          redirect_to :controller => :admin, :action => :cerca_rapporti
          return
    end
    #
    if @rapporti[0].nil? || @rapporti.empty?
      flash[:error] = "Errore: stai tentando di inviare un email per un rapporto inesistente)"
      redirect_to :controller => :rapporti
    else
      @cliente = @rapporti[0].campione.cliente
      testo_default = Parametro.find_by_codice('email_testo_invio_rdp_e_anteprime')
      if testo_default.nil?
        flash[:error] =  "ERRORE: nella tabella parametri manca il parametro 'email_testo_rapporto_pronto'"
        redirect_to :controller => :rapporti
        return
      else
        @testo_default = testo_default.valore
      end
      mittente_default = Parametro.find_by_codice('email_mittente_per_notifiche')
      if mittente_default.nil?
        flash[:error] =  "ERRORE: nella tabella parametri manca il parametro 'email_mittente_per_notifiche'"
        redirect_to :controller => :rapporti
        return
      else
        @mittente_default = mittente_default.valore
      end
      oggetto_default = Parametro.find_by_codice('email_oggetto_invio_rdp_e_anteprime')
      if oggetto_default.nil?
        flash[:error] =  "ERRORE: nella tabella parametri manca il parametro 'email_oggetto_rapporto_pronto'"
        redirect_to :controller => :rapporti
        return
      else
        @oggetto_default = oggetto_default.valore
      end

      @destinatario_default = @cliente.email_per_notifiche
      if @destinatario_default.blank?
        flash[:error] =  "ERRORE: manca l'indirizzo email del cliente"
        redirect_to :controller => :clienti, :action => :edit, :id => @cliente.id
        return
      end

      @indirizzo_bcc =  Parametro.first(:conditions => [ "codice = ?", 'email_bcc_per_notifiche' ]).valore unless  Parametro.first(:conditions => [ "codice = ?", 'email_bcc_per_notifiche' ]).nil?

      # Invia Email
      if params[:commit] == 'Invia'
        # invio l'email
        messaggio = params[:testo_corretto]
        mittente = @mittente_default
        destinatario = params[:destinatario_corretto]# @destinatario_default
        oggetto = params[:oggetto_corretto]
        # preparo gli allegati
        # Allego ANTEPRIMA
        files_array = []
        unless params[:email_anteprima_array].nil?
          @codice_senza_render = true
          params[:rapporty_array] = params[:email_anteprima_array]
          # qui sta il trucco... chiamo il metodo senza generare il render (!)
          anteprima_risultati
          anteprima_risultati = make_pdf(:template => "rapporti/anteprima_risultati.erb",  :pdf => "anteprima_risultati", :stylesheets => ["anteprima_risultati", "prince"], :layout => "anteprima_risultati")
          files_array = [{:filename => 'Anteprima_risultati.pdf', :file => anteprima_risultati}]
        end
        # Allego RDP
        # se arrivo con un ID allego solo il RDP di quel rapporto
        if params[:id]
          @rapporti_email_rdp = [Rapporto.find_by_id(params[:id])]
        end
        unless @rapporti_email_rdp.nil?
          @rapporti_email_rdp.each do |rapporto|
            #@codice_senza_render = true
            #params[:id] = rapporto.id
            #rdp
            #rdp = make_pdf(:template => "rapporti/rdp.erb",  :pdf => "rdp", :stylesheets => ["rdp", "prince"], :layout => "rdp")
            #files_array << {:filename => "Rdp_#{rapporto.numero unless rapporto.numero}#{}_su_campione#{rapporto.campione.numero}.pdf", :file => rdp}
            nome_file = rapporto.nome_file_pdf_del_rapporto_con_path_assoluto
            if File.exist?(nome_file)
              file_data = IO.read(nome_file)
              files_array << {:filename => "Rdp_#{rapporto.numero unless rapporto.numero}#{}_su_campione#{rapporto.campione.numero}.pdf", :file => file_data}
            end
          end
        end
        # invio l'email
        errori = invia_email_e_restituisce_errori(messaggio, destinatario, mittente, oggetto, files_array)
        if errori.nil?
          # ok
          flash[:error] = 'email correttamente inviata'
          # aggiorno data invio email
          @rapporti.each{|rapporto| rapporto.update_attribute(:data_invio_email, Time.now)}
        else
          # errore
          flash[:error] = errori
          # ma qui il flash mi arriva già popolato
        end
        redirect_to :controller => :admin, :action => :cerca_rapporti
      else
        # non invio email ed invece visualizzo
        @link_anteprima = '/rapporti/anteprima_risultati?'
        @rapporti.each {|rapporto| @link_anteprima += "rapporty_array[]=#{rapporto.id}&"}
        @link_anteprima += 'format=pdf'
      end
    end
  end

  def invia_sms
    if params[:id].nil?
      if params[:sms_array].nil? && params[:sms_array].nil?
        flash[:error] = "Seleziona i rapporti ai quali vuoi inviare l'sms"
        redirect_to :controller => :admin, :action => :cerca_rapporti
        return
      else
        @rapporti_sms     =  params[:sms_array].map{|rapporto_id| Rapporto.find_by_id(rapporto_id.to_i)} unless params[:sms_array].nil?
        @rapporti =  @rapporti_sms || []
        @rapporti.uniq!
      end
    else
      @rapporti = [Rapporto.find_by_id(params[:id])]
      @rapporto = @rapporti[0]
    end

    # controllo che abbia selezionato rapporti dello stesso cliente
    # se NON params[:cliente_id].nil? allora posso stare tranquillo, altrimenti controllo
    if params[:cliente_id].nil? && @rapporti.map{|rapporto| rapporto.campione.cliente.id}.uniq.size > 1
          flash[:error] = "Per inviare sms su più di un rapporto devi selezionare solo rapporti dello stesso cliente"
          redirect_to :controller => :admin, :action => :cerca_rapporti
          return
    end

    @rapporto = Rapporto.find_by_id(params[:id])
    #
    if @rapporti[0].nil? || @rapporti.empty?
      flash[:error] = "Errore: stai tentando di inviare un sms per un rapporto inesistente)"
      redirect_to :controller => :rapporti
    else
      @cliente = @rapporti[0].campione.cliente
      testo_default = Parametro.find_by_codice('sms_testo_rapporto_pronto')
      if testo_default.nil?
        flash[:error] =  "ERRORE: nella tabella parametri manca il parametro 'sms_testo_rapporto_pronto'"
        redirect_to :controller => :rapporti
        return
      else
        @testo_default = testo_default.valore
      end
      mittente_default = Parametro.find_by_codice('sms_numero_mittente')
      if mittente_default.nil?
        flash[:error] =  "ERRORE: nella tabella parametri manca il parametro 'sms_numero_mittente'"
        redirect_to :controller => :rapporti
        return
      else
        @mittente_default = mittente_default.valore
      end
      @destinatario_default = @rapporti[0].campione.cliente.cellulare_per_sms
      if @destinatario_default.blank?
        flash[:error] =  "ERRORE: manca il numero di sms del cliente"
        redirect_to :controller => :clienti, :action => :edit, :id => @rapporti[0].campione.cliente.id
        return
      end
      #
      if params[:commit] == 'Invia'
        # invio l'sms
        messaggio = params[:testo_corretto]
        mittente = @mittente_default
        destinatario = params[:destinatario_corretto]# @destinatario_default
        errori = @rapporti[0].invia_sms_per_rapporto_e_restituisce_errori(messaggio, destinatario, mittente)
        if errori.nil?
          # ok
          flash[:error] = 'messaggio correttamente inviato'
          @rapporti.each{|rapporto| rapporto.update_attribute(:data_invio_sms,Time.now)}
        else
          # errore
          flash[:error] = errori
          # ma qui il flash mi arriva già popolato
        end
        redirect_to :controller => :admin, :action => :cerca_rapporti
      end
    end
  end

  # GET /rapporti/new - Required by ActiveScaffold
  def new
    @rapporto = Rapporto.new
    
    # Se viene passato un campione_id, lo preimposto
    if params[:campione_id]
      @rapporto.campione_id = params[:campione_id]
    end
    
    # Imposto la data richiesta a oggi per default
    @rapporto.data_richiesta = Date.today
    
    super # Chiama il metodo new di ActiveScaffold
  end

  # Override create to ensure @record is properly set for ActiveScaffold
  def create
    # Use ActiveScaffold's parameter structure (record instead of rapporto)
    do_create
    # Ensure @record is set for error display
    @record = @rapporto if @rapporto
  end

# Commented out duplicate methods to avoid conflicts with ActiveScaffold
end
