class Notification < ActionMailer::Base
  

#  def welcome(sent_at = Time.now)
#    subject    'Notification#welcome'
#    recipients ''
#    from       ''
#    sent_on    sent_at
#
#    body       :greeting => 'Hi,'
#  end

 #
 # da http://www.devarticles.com/c/a/Ruby-on-Rails/Error-Checking-and-Debugging-with-Ruby-on-Rails/
 # excerpted from chapter 15 of the Ruby Cookbook, written by Lucas Carlson and Leonard Richardson (O'Reilly, 2006; ISBN: 0596523696)
  def error_message(exception, trace, session, params, env, sent_on = Time.now)
      @recipients    = 'francesco@buenaventura.it'
      @from          = 'error@centroenowine.dyndns.org'
      @subject       = "Errore su centroenowine.dyndns.org"#:  #{request.env['REQUEST_URI']}"
      # { env['REQUEST_URI']}"
      # Variabili d'ambiente utili ricavabili da hash ENV, es
      # ENV['RAILS_ENV'] che è 'development' o 'production'
      # ENV['PWD'] che è '/home/dante/rails/barbera'
      @sent_on       = sent_on
      @body = {
        :greeting => 'Ciao,',
        :exception => exception,
        :trace => trace,
        :session => session,
        :params => params,
        :env => env
      }
  end

  def messaggio_rapporto_pronto(message, recipient, sender, oggetto)
      @recipients    = 'oriettaxx@gmail.com'#recipient
      @from          = sender
      @subject       = oggetto
      @sent_on       = Time.now
      @body = {
        :greeting => 'Ciao,',
        :messaggio => message

      }
      @attachment = { :content_type => "image/gif", :body => File.read("public/images/logo.gif")}

  end

  def email_generica(message, recipient, sender, oggetto, files_array)
    @recipients    = recipient #'oriettaxx@gmail.com'#
    @from          = sender
    @subject       = oggetto
    @sent_on       = Time.now
    @body = {
      :greeting => 'Ciao,',
      :messaggio => message

    }
    indirizzo_bcc =  Parametro.first(:conditions => [ "codice = ?", 'email_bcc_per_notifiche' ]).valore unless Parametro.first(:conditions => [ "codice = ?", 'email_bcc_per_notifiche' ]).nil?
    unless indirizzo_bcc.nil?
      @bcc =  indirizzo_bcc
    end

    files_array.each do |myfile|
      attachment   "application/pdf" do |a|
        a.filename = myfile[:filename] || 'Allegato.pdf'
        a.body = myfile[:file] # File.read(email_attachment)
      end
    end

    #
#            attachment :content_type => "image/jpeg",
#        :body => File.read("#{RAILS_ROOT}/public/images/rdp_intestazione.jpg")
      
#      attachment "application/pdf" do |a|
#        #a.body = generate_your_pdf_here()
#        # FUNZIONA:
#        # a.body = File.read("#{RAILS_ROOT}/public/file.pdf")
#        #a.body = render :controller => :rapporti, :pdf => "anteprima_risultati", :stylesheets => ["anteprima_risultati", "prince"], :layout => "anteprima_risultati", 'rapporty_array[]'=40&format=pdf
#        a.body = make_pdf("file_name",  {:pdf => "rdp", :stylesheets => ["rdp", "prince"], :layout => "rdp", :controller => :rapporti, :action => 'rdp', :id => 40})
#        #render  :pdf => "rdp", :stylesheets => ["rdp", "prince"], :layout => "rdp", :controller => :rapporti, :action => 'rdp', :id => 40
##        respond_to do |format|
##        format.html {render :layout => 'anteprima_risultati'}
##        format.pdf do
##          # default are
##          # layout:      false
##          # template:    the template for the current controller/action
##          # stylesheets: none
##          render :pdf => "anteprima_risultati", :stylesheets => ["anteprima_risultati", "prince"], :layout => "anteprima_risultati"
##        end
##      end
#      end

    #@attachments['filename.jpg'] = File.read("#{RAILS_ROOT}/public/images/rdp_intestazione.jpg") #{ :content_type => "image/gif", :body => File.read("#{RAILS_ROOT}/public/images/logo.gif")}
#    attachment   "application/pdf" do |a|
#      a.filename= "my_survival_kit.pdf"
#      a.body = myfile # File.read(email_attachment)
#    end
#
  end


end