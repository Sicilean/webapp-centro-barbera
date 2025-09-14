# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  config.gem "authlogic"

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  # config.time_zone = 'UTC'
  config.time_zone = 'Rome'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
  config.i18n.default_locale = :it
end

require 'config/controlla_codice_fiscale'
require 'config/controlla_partita_iva'
require 'digest/md5'

# Activate Mailer - Agile p. 505
# aggiunto per spedire notifiche di errore

ActionMailer::Base.delivery_method = :sendmail
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_charset = "utf-8"

# Variabili d'ambiente utili ricavabili da hash ENV, es
# ENV['RAILS_ENV'] che è 'development' o 'production'
# ENV['PWD'] che è '/home/dante/rails/barbera'

#SMS_LOGIN = 'F05740'
#SMS_PASSWORD = '487kp3q3'
#SMS_DEFAUL_SENDER = 393205747294# 93205747294" # Max 11 Characters alphanumeric OR number, i.e. "+XXYYYZZZZZZ" see other/mobyt_module_http_fr.rtf
SMS_COMPANY_NAME = "Mobyt.fr"
SMS_COMPANY_LINK = "http://www.mobyt.fr"
SMS_LOGIN_LINK = "http://multilevel.mobyt.fr"
SMS_SENDING_LINK = "http://multilevel.mobyt.fr/sms/send.php" # usata
SMS_CHECKING_CREDIT_LINK = "http://multilevel.mobyt.fr/sms/credit.php"
SMS_WORLD_COVERAGE = "http://www.mobyt.fr/mobyt_coverage.pdf"
SMS_QUALITY = 'l' # (l = standard, ll = low cost, n = top)
DIRECTORY_RELATIVA_PDF_RAPPORTI = 'pdf' # ricordarsi di crearla
DIRECTORY_ASSOLUTA_PDF_RAPPORTI = File.join(RAILS_ROOT, DIRECTORY_RELATIVA_PDF_RAPPORTI) # ovvero ~/rails/centroenowine.dyndns.org/pdf

ERRORE_TAG = 'ERRORE'
USER_ROLE_TYPES = [
                    ['amministratore', 10], # non modificare!
                    ['operatore', 20], # non modificare!
                    ['cliente', 30]]

CLIENTE_PROVINCIA_TYPES = [
                            [" ",""],
                            ["Trapani - TP","TP"],
                            ["Palermo - PA","PA"],
                            ["Siracusa - SR","SR"],
                            ["---altre---",""],
                            ["Agrigento - AG","AG"],
                            ["Alessandria - AL","AL"],
                            ["Ancona - AN","AN"],
                            ["Aosta - AO","AO"],
                            ["Arezzo - AR","AR"],
                            ["Ascoli Piceno - AP","AP"],
                            ["Asti - AT","AT"],
                            ["Avellino - AV","AV"],
                            ["Bari - BA","BA"],
                            ["Belluno - BL","BL"],
                            ["Benevento - BN","BN"],
                            ["Bergamo - BG","BG"],
                            ["Biella - BI","BI"],
                            ["Bologna - BO","BO"],
                            ["Bolzano - BZ","BZ"],
                            ["Brescia - BS","BS"],
                            ["Brindisi - BR","BR"],
                            ["Cagliari - CA","CA"],
                            ["Caltanissetta - CL","CL"],
                            ["Campobasso - CB","CB"],
                            ["Carbonia-Iglesias - CI","CI"],
                            ["Caserta - CE","CE"],
                            ["Catania - CT","CT"],
                            ["Catanzaro - CZ","CZ"],
                            ["Chieti - CH","CH"],
                            ["Como - CO","CO"],
                            ["Cosenza - CS","CS"],
                            ["Cremona - CR","CR"],
                            ["Crotone - KR","KR"],
                            ["Cuneo - CN","CN"],
                            ["Enna - EN","EN"],
                            ["Ferrara - FE","FE"],
                            ["Firenze - FI","FI"],
                            ["Foggia - FG","FG"],
                            ["Forlì-Cesena - FC","FC"],
                            ["Frosinone - FR","FR"],
                            ["Genova - GE","GE"],
                            ["Gorizia - GO","GO"],
                            ["Grosseto - GR","GR"],
                            ["Imperia - IM","IM"],
                            ["Isernia - IS","IS"],
                            ["La Spezia - SP","SP"],
                            ["L'Aquila - AQ","AQ"],
                            ["Latina - LT","LT"],
                            ["Lecce - LE","LE"],
                            ["Lecco - LC","LC"],
                            ["Livorno - LI","LI"],
                            ["Lodi - LO","LO"],
                            ["Lucca - LU","LU"],
                            ["Macerata - MC","MC"],
                            ["Mantova - MN","MN"],
                            ["Massa-Carrara - MS","MS"],
                            ["Matera - MT","MT"],
                            ["Messina - ME","ME"],
                            ["Milano - MI","MI"],
                            ["Modena - MO","MO"],
                            ["Napoli - NA","NA"],
                            ["Novara - NO","NO"],
                            ["Nuoro - NU","NU"],
                            ["Olbia-Tempio - OT","OT"],
                            ["Oristano - OR","OR"],
                            ["Padova - PD","PD"],
                            ["Parma - PR","PR"],
                            ["Pavia - PV","PV"],
                            ["Perugia - PG","PG"],
                            ["Pesaro e Urbino - PU","PU"],
                            ["Pescara - PE","PE"],
                            ["Piacenza - PC","PC"],
                            ["Pisa - PI","PI"],
                            ["Pistoia - PT","PT"],
                            ["Pordenone - PN","PN"],
                            ["Potenza - PZ","PZ"],
                            ["Prato - PO","PO"],
                            ["Ragusa - RG","RG"],
                            ["Ravenna - RA","RA"],
                            ["Reggio Calabria - RC","RC"],
                            ["Reggio Emilia - RE","RE"],
                            ["Rieti - RI","RI"],
                            ["Rimini - RN","RN"],
                            ["Roma - RM","RM"],
                            ["Rovigo - RO","RO"],
                            ["Salerno - SA","SA"],
                            ["Medio Campidano - VS","VS"],
                            ["Sassari - SS","SS"],
                            ["Savona - SV","SV"],
                            ["Siena - SI","SI"],
                            ["Sondrio - SO","SO"],
                            ["Taranto - TA","TA"],
                            ["Teramo - TE","TE"],
                            ["Terni - TR","TR"],
                            ["Torino - TO","TO"],
                            ["Ogliastra - OG","OG"],
                            ["Trento - TN","TN"],
                            ["Treviso - TV","TV"],
                            ["Trieste - TS","TS"],
                            ["Udine - UD","UD"],
                            ["Varese - VA","VA"],
                            ["Venezia - VE","VE"],
                            ["Verbano-Cusio-Ossola - VB","VB"],
                            ["Vercelli - VC","VC"],
                            ["Verona - VR","VR"],
                            ["Vibo Valentia - VV","VV"],
                            ["Vicenza - VI","VI"],
                            ["Viterbo - VT","VT"],
                          ]
VARIABILE_TIPO_TYPES = [
                        ['-seleziona-',''],
                        ['Valore da inserire (sorgente)- VERDE', 'input-valore'],
                        ['Testo da inserire (sorgente) - VERDE', 'input-testo'],
                        ['Valore da calcolare con funzione - ROSSO','funzione']
                        ]
VARIABILE_DECIMALI_TYPES =  [['--','']]+(0..8).map{|x| [x.to_s, x]}
#CAMPIONE_STATUS_TYPES =   [['Accettato', 'Accettato'],
#                        ['In lavorazione','In lavorazione'],
#                        ['Pronto','Pronto']]
CAMPIONE_RC_ANNO_TYPES = (2010..2020).map{|x| [x.to_s, x]}
CAMPIONE_RDP_ANNO_TYPES = CAMPIONE_RC_ANNO_TYPES

RAPPORTO_STATUS_TYPES = [
  # nb, mettere per primo il valore che viene assegnato alla creazione del rapporto
  ['in lavorazione', 'in lavorazione'],
  ['completo', 'completo'],
  ]

RAPPORTO_STATUS_DEFAULT = RAPPORTO_STATUS_TYPES[0][1]

IVA = 0.20

def show_regexp(testo, regular_expression)
  # PickAxe p. 67
  if testo =~ regular_expression
    "#{$`}<<#{$&}>>#{$'}"
  else
    'no match'
  end
end

def get_variabile(simbolo, matrice)
  if simbolo.blank? || matrice.blank? || matrice.class != Matrice
    return nil
  else
    #
    Variabile.first(:conditions => ["matrice_id = ? AND simbolo = ?", matrice.id, simbolo])
  end
end

def simboli_per_funzione(funzione)
  # ritorna array con i simboli contenuti nella funzione
  if funzione.blank?
    return []
  else
    my_array = Array.new
    # visto i controlli fatti in fase di validazione, posso garantire la seguente
    funzione.gsub(/[A-Z]{1,4}/) {|match| my_array << match }
    # risultato è array di tutti i simboli (la cui matrice ovviamente è la stessa della variabile)
    return my_array.uniq # levo le doppie 
  end
end

def variabili_indipendenti_per_funzione(funzione, matrice)
  if funzione.blank?
    return []
  else
    risultato = simboli_per_funzione(funzione).map {|simbolo| get_variabile(simbolo,matrice)}
    if risultato.include?(nil)
      # QUI c'è un errore, in quando la formula prevede variabili non presenti nel DB
      #provoco_errore
      2/0
      logger.error("Ci sono variabili non definite nella formula")
    else
      return risultato
    end
  end
end

def variabili_indipendenti_che_sono_funzioni_per_funzione(funzione, matrice)
    return variabili_indipendenti_per_funzione(funzione, matrice).map{|variabile| variabile if variabile.is_funzione?}.compact # compact necessario per levare i 'nil'
end

def invia_sms_e_restituisce_errori(message, recipient, sender)
  sender = "39" + sender
  recipient = "39" + recipient
  errori = controlla_parametri_sms_e_restituisce_errori(message, recipient, sender)
  if errori.nil?
    esito = invia_sms(message, recipient, sender)
    return esito
  else
    return errori
  end
end

def controlla_parametri_sms_e_restituisce_errori(message, recipient, sender)
  if recipient.to_s.size <10
    return "Numero destinatario (#{recipient}) errato: immetti solo cifre (almeno 10)"
  end
  #if recipient.mb_chars.index('+')!=0
  #  flash[:notice]= "ERR: Ricorda il '+'"
  #end
  #if sender.mb_chars.index('+')!=0
  #  flash[:notice]= "ERR: Ricorda il '+'"
  #end
  if  Parametro.find_by_codice('sms_provider_login').nil?
    return "ERRORE: nella tabella parametri manca il parametro 'sms_provider_login'"
  end
  if Parametro.find_by_codice('sms_provider_password').nil?
    return "ERRORE: nella tabella parametri manca il parametro 'sms_provider_password'"
  end
  if sender.to_s.size <10
    return 'ERR: Numero mittente errato (troppo breve)'
  end
  if message.blank?
    return 'ERR: Testo vuoto'
  end
  return nil
end

def invia_sms(message, recipient, sender)
  # see other/mobyt_module_http_fr.rtf
  # rcpt – Numéro destinataire au format international +XXYYYZZZZZZ
  # data – Texte du message (maximum 160 caractères)
  # sender – Expéditeur du message (maximum 11 caractères alphanu+XXYYYZZZZZZ)
  # qty – Qualité du message : (l = standard, ll = low cost, n = top)
  #
  myurl = SMS_SENDING_LINK
  # cut SMS TEXT to maximum size, which is 160
  #message=my_truncate(message,160,"..") # this is maybe a double check for already made truncate in the call
  par_user =  Parametro.find_by_codice('sms_provider_login').valore
  par_pass =  Parametro.find_by_codice('sms_provider_password').valore
  par_rcpt = '+'+recipient.to_s
  par_data = message
  par_sender = '+'+sender.to_s# Max 11 Characters alphanumeric OR number, i.e. "+XXYYYZZZZZZ" see other/mobyt_module_http_fr.rtf
  par_qty  = SMS_QUALITY
  parameters = {'user'   => par_user,
                'pass'   => par_pass,
                'rcpt'   => par_rcpt,
                'data'   => par_data,
                'sender' => par_sender,
                'qty'    => par_qty,
                'ticket' => Digest::MD5.hexdigest(par_user+par_rcpt+par_sender+par_data+par_qty+Digest::MD5.hexdigest(par_pass))
  }
  # response.message 'OK' if remote page is loaded, even if sms is not sent
  # response.body    il codice HTML della pagina
  # response.code    codice risultato operazione

  res = Net::HTTP.post_form(URI.parse(myurl), parameters)
  if res.message == 'OK'
    # il server ha risposto... ma forse in modo negativo
    if res.body[0,2] == 'OK'
      # il server ha mandato il messaggio
      return nil
    else
      #return "Recipient: #{parameters['rcpt']}<br>Message:  #{parameters['data']}<br>Sender: #{parameters['sender']}<br><br>Il provider ha risposto: <b>#{res.body}</b>"
      return "Errore nella spedizione dell'sms.  Il provider ha risposto: #{res.body}"
    end
  else
    return 'Errore, non riesco a raggiungere il provider: '+myurl+' (manca forse il collegamento ad internet?'
  end
end

def check_sms_credit(type = "l")
  # type = "credit" for euro, or "l" for number of sms
  # organization = id dell'organizzazione a cui addebitare gli sms
  myurl = SMS_CHECKING_CREDIT_LINK
    parameters =  {'user'=>SMS_LOGIN, 'pass'=>SMS_PASSWORD, 'u_id' =>SMS_LOGIN, 'type' => type}
    #
    # response.message 'OK' se pagina caricata
    # response.body    il codice HTML della pagina
    # response.code    codice risultato operazione
    # nb     SMS_CHECKING_CREDIT_LINK = "http://www.iperserver.it/sk_sms/PHP/examples/sms-credit.php"
    # http://www.iperserver.it/sk_sms/PHP/examples/sms-credit.php?password=kw3uiqwqdy0&login=C13506_001
    res = Net::HTTP.post_form(URI.parse(myurl), parameters)
    if res.message == 'OK'
      flash[:notice]= res.body
    else
      flash[:notice]= 'Error: could not reach the following url: '+SMS_CHECKING_CREDIT_LINK+' try maybe later'
    end
end


def invia_email_e_restituisce_errori(message, recipient, sender, oggetto, files_array = nil)
  Notification.deliver_email_generica(message, recipient, sender, oggetto, files_array)
  return nil
end

# la seguente copiata da /usr/lib/ruby/gems/1.8/gems/actionpack-2.3.5/lib/action_view/helpers/number_helper.rb
def my_number_with_precision(number, *args)
  options = args.extract_options!
  options.symbolize_keys!

  defaults           = I18n.translate(:'number.format', :locale => options[:locale], :raise => true) rescue {}
  precision_defaults = I18n.translate(:'number.precision.format', :locale => options[:locale],
                                                                  :raise => true) rescue {}
  defaults           = defaults.merge(precision_defaults)

  precision ||= (options[:precision] || defaults[:precision])
  separator ||= (options[:separator] || defaults[:separator])
  delimiter ||= (options[:delimiter] || defaults[:delimiter])

  begin
    rounded_number = (Float(number) * (10 ** precision)).round.to_f / 10 ** precision
    my_number_with_delimiter("%01.#{precision}f" % rounded_number,
      :separator => separator,
      :delimiter => delimiter)
  rescue
    number
  end
end

# la seguente copiata da /usr/lib/ruby/gems/1.8/gems/actionpack-2.3.5/lib/action_view/helpers/number_helper.rb
# necessaria per my_number_with_precision()
def my_number_with_delimiter(number, *args)
  options = args.extract_options!
  options.symbolize_keys!

  defaults = I18n.translate(:'number.format', :locale => options[:locale], :raise => true) rescue {}

  unless args.empty?
    ActiveSupport::Deprecation.warn('number_with_delimiter takes an option hash ' +
      'instead of separate delimiter and precision arguments.', caller)
    delimiter = args[0] || defaults[:delimiter]
    separator = args[1] || defaults[:separator]
  end

  delimiter ||= (options[:delimiter] || defaults[:delimiter])
  separator ||= (options[:separator] || defaults[:separator])

  begin
    parts = number.to_s.split('.')
    parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{delimiter}")
    parts.join(separator)
  rescue
    number
  end
end


def stringa_per_data_valida?(stringa)
  # se scelgo il 31 febbraio, torno indietro di un giorno...
  begin
    stringa.to_date
    return true
  rescue
    return false
  end
end

#def nome_file_pdf_del_rapporto(rapporto)
#  if rapporto.anno.blank? || rapporto.numero.blank?
#    raise "Errore: stai tentando di salvare un PDF senza anno o numero di Rdp. Avvertire Francesco"
#  else
#    return "Rdp_#{rapporto.anno}_#{rapporto.numero}#{('_s_'+rapporto.numero_supplemento.to_s) unless rapporto.numero_supplemento.blank?}.pdf"
#  end
#end

#def nome_file_pdf_del_rapporto_con_path_assoluto(rapporto)
#  File.join(DIRECTORY_ASSOLUTA_PDF_RAPPORTI, nome_file_pdf_del_rapporto(rapporto))
#end
#
#def nome_file_pdf_del_rapporto_di_backup_con_path_assoluto(rapporto)
#  File.join(DIRECTORY_ASSOLUTA_PDF_RAPPORTI,File.basename(nome_file_pdf_del_rapporto_con_path_assoluto(rapporto), '.pdf')+'.bak.pdf' ) # => 'Rdp_2010_1007.bak.pdf'
#end