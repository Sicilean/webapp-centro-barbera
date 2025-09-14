# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  # nb per eseguire script devi annullare il riconoscimento dell'utente
  # lo si fa commentando
  #    * la riga qui sotto
  #    *  before_filter :require_admin_or_operator  in admin_controller
  #    * aggiungendo       @current_user = User.find(1) nel metodo current_user qui sotto

  filter_parameter_logging :password, :password_confirmation

 
  #MAI attivare questo, altrimenti Active Scaffold fa casino e mi usa degli helper
  #ove non deve
  #MAI !!!helper :all # include all helpers, all the time

  #forgery disabilitato (serve veramente?)
  #protect_from_forgery # See ActionController::RequestForgeryProtection for details

  ActiveScaffold.set_defaults do |config|
    config.ignore_columns.add [:created_at, :updated_at]
    #config.show.link.label   = 'Mostra'
    #config.update.link.label = 'Modifica'
    #config.delete.link.label = 'Elimina'
    config.list.per_page = 1000
    # live search
    # la seguente va e non va... provo a metterla nei singoli controller
    # config.actions.swap :search, :live_search
    # la di sopra non va se uso la traduzione:
    #config.search.link.label = 'Cerca'

  end

  helper_method :current_user

#  # icludo helper nel controller (mi serve per number with precision in mostra valore variabile_rapporto_items
#
#  def help
#    Helper.instance
#  end
#  class Helper
#    include Singleton
#    include ActionView::Helpers::NumberHelper    # per number_with_precision in  mostra_variabile_rapporto_item_valore_automatico
#  end


  private

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      # Accesso automatico come amministratore
      return @current_user if defined?(@current_user)
      @current_user = User.find_by_email('francesco@buenaventura.it')
      return @current_user
    end

    def require_user
      unless current_user
        store_location
        flash[:notice] = "Devi entrare per eseguire questa operazione"
        redirect_to login_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = "Devi essere uscito per eseguire questa operazione"
        redirect_to logout_url
        return false
      end
    end

    def store_location
      session[:return_to] = request.request_uri
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    def require_admin_or_operator
      unless (current_user && current_user.is_admin_or_operator?)
        store_location
        flash[:notice] = "Ruolo insufficiente"
        redirect_to login_url
        return false
      end
    end
    def require_admin
      unless (current_user && current_user.is_admin?)
        store_location
        flash[:notice] = "Ruolo insufficiente"
        redirect_to login_url
        return false
      end
    end

    # the following to add email error notification
    # see http://www.devarticles.com/c/a/Ruby-on-Rails/Error-Checking-and-Debugging-with-Ruby-on-Rails/
    # excerpted from chapter 15 of the Ruby Cookbook, written by Lucas Carlson and Leonard Richardson (O'Reilly, 2006; ISBN: 0596523696)

    def log_error(exception)
         super
         Notification.deliver_error_message(exception,
           clean_backtrace(exception),
           session.instance_variable_get("@data"),
           params,
           request.env
         )
    end

 

  end

     def crea_e_restituisci_duplicato_del_rapporto_su_campione(rapporto_originale_id, campione_al_quale_assegnarlo_id = nil)
      rapporto_originale = Rapporto.find(rapporto_originale_id)
      if rapporto_originale.nil?
        flash[:error] = 'Errore: stai tentando di duplicare un rapporto inesistente'
        return nil
      else
        # se manca il campione, lo assengo allo stesso
        campione_al_quale_assegnarlo_id = rapporto_originale.campione.id if campione_al_quale_assegnarlo_id.nil?
        # non faccio il clone, altrienti rischio in futuro di portarmi appresso valori che non controllo
        # rapporto_nuovo = rapporto_originale.clone
        rapporto_nuovo = Rapporto.new(
          :campione_id    => campione_al_quale_assegnarlo_id,
          :tipologia_id => rapporto_originale.tipologia.id,
          :data_esecuzione_prove_inizio =>  rapporto_originale.data_esecuzione_prove_inizio,
          :data_esecuzione_prove_fine   =>  rapporto_originale.data_esecuzione_prove_fine,
          #:note         => "< DUPLICATO DI RAPPORTO #{('n. '+rapporto_originale.numero.to_s) unless rapporto_originale.numero.nil? } #{'anno '+rapporto_originale.anno.to_s unless rapporto_originale.anno.nil?} > #{rapporto_originale.note}",
          :data_richiesta => Time.now
        )
        # Salvo
        if rapporto_nuovo.save
          # il rapporto è salvato, ora salvo le prove aggiuntive
          # PROVE AGGIUNTIVE
          #  has_many :prova_rapporto_items, :dependent => :destroy, :order => 'position ASC'
          #  has_many :prove, :through => :prova_rapporto_items
          rapporto_originale.prova_rapporto_items.each do |prova_rapporto_item|
            # ATTENZIONE la seguente è errata, andrea a spostare l'originale!!!!
            # rapporto_nuovo.prova_rapporto_items << prova_rapporto_item
            prova_rapporto_item_nuovo = ProvaRapportoItem.new(
                     :rapporto_id => rapporto_nuovo.id,
                     :prova_id    => prova_rapporto_item.prova_id,
                     :position    => prova_rapporto_item.position)
            unless prova_rapporto_item_nuovo.save
              flash[:error] =  'Errore: non riesco a salvarare le prove aggiuntive. Avvertire Francesco'
            end
          end
          rapporto_nuovo.reload
          # il rapporto è salvato, ed anche le prove aggiuntive, ma sono state sincronizzate le variabili, quindi sono state CREATE
          # con valori vuoti, ora le cancello e le ricreo
          rapporto_nuovo.variabile_rapporto_items.each do |variabile_rapporto_item|
             variabile_rapporto_item.destroy
          end
          # VARIABILI
          #  has_many :variabile_rapporto_items, :dependent => :destroy
          #  has_many :variabili, :through => :variabile_rapporto_items
          rapporto_originale.variabile_rapporto_items.each do |variabile_rapporto_item|
            variabile_rapporto_item_nuovo = VariabileRapportoItem.new(
                    :rapporto_id => rapporto_nuovo.id,
                    :variabile_id          => variabile_rapporto_item.variabile_id,
                    :valore_numero         => variabile_rapporto_item.valore_numero,
                    :valore_testo          => variabile_rapporto_item.valore_testo,
                    :errore                => variabile_rapporto_item.errore,
                    :incertezza_di_misura  => variabile_rapporto_item.incertezza_di_misura,
                    :valore_numero_forzato => variabile_rapporto_item.valore_numero_forzato
            )
            unless variabile_rapporto_item_nuovo.save
              flash[:error] =  'Errore: non riesco a salvarare le variabili. Avvertire Francesco'
            end
          end
          # ora risalvo il rapporto, così sono sicuro di avere i prezzi aggiornati
          # ed anche le variabili, che nel frattempo possono essere state modificate !!!!
          if rapporto_nuovo.save
            return rapporto_nuovo
          else
            flash[:error] = 'Errore: su ultimo ultimo salvataggio rapporto clonato. Avvertire Francesco'
            return nil
          end
        else
          flash[:error] = 'Errore: non riesco a salvarare il rapporto clonato. Avvertire Francesco'
          return nil
        end
      end
    end