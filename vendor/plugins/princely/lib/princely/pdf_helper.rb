module PdfHelper
  require 'princely'
  
  def self.included(base)
    base.class_eval do
      alias_method_chain :render, :princely
    end
  end
  
  def render_with_princely(options = nil, *args, &block)
    if options.is_a?(Hash) && options.has_key?(:pdf)
      options[:name] ||= options.delete(:pdf)
      make_and_send_pdf(options.delete(:name), options)      
    else
      render_without_princely(options, *args, &block)
    end
  end  
    
  private
  
  def make_pdf(options = {})
    options[:stylesheets] ||= []
    options[:layout] ||= false
    options[:template] ||= File.join(controller_path,action_name)
    
    prince = Princely.new()
    
    # Assicura che i CSS esistano prima di aggiungerli
    valid_stylesheets = options[:stylesheets].select do |style|
      css_path = stylesheet_file_path(style)
      File.exist?(css_path)
    end
    
    # Aggiungi sempre il CSS prince se esiste
    prince_css_path = stylesheet_file_path('prince')
    valid_stylesheets << 'prince' if File.exist?(prince_css_path)
    
    # Sets style sheets on PDF renderer
    prince.add_style_sheets(*valid_stylesheets.collect{|style| stylesheet_file_path(style)})
    
    begin
      html_string = render_to_string(:template => options[:template], :layout => options[:layout])
      
      # Prepara l'HTML per wkhtmltopdf
      html_string = prepare_html_for_pdf(html_string)
      
      # DEBUG: salva l'HTML generato per ispezione nel caso di errori
      File.open("#{RAILS_ROOT}/log/last_pdf_html.html", "w") { |f| f.write(html_string) }
      
      # Send the generated PDF file from our html string.
      pdf_data = if filename = options[:filename] || options[:file]
        prince.pdf_from_string_to_file(html_string, filename)
      else
        prince.pdf_from_string(html_string)
      end
      
      if pdf_data.nil? || pdf_data.empty? || !pdf_data.start_with?("%PDF")
        logger.error "ERRORE PDF: PrinceXML ha restituito PDF non valido per il template #{options[:template]}!"
        logger.error "Controlla il file log/last_pdf_html.html e le variabili della view"
        logger.error "Opzioni di rendering: #{options.inspect}"
        logger.error "Stylesheets validi trovati: #{valid_stylesheets.inspect}"
        
        # Creare un PDF minimo ma valido come fallback
        fallback_pdf = create_fallback_pdf("Errore nella generazione del PDF", 
                                        "Si è verificato un errore durante la generazione del PDF.\nContattare l'amministratore del sistema.")
        return fallback_pdf
      end
      
      return pdf_data
    rescue => e
      logger.error "ERRORE RENDER PDF: #{e.message}"
      logger.error e.backtrace.join("\n")
      
      # Creare un PDF minimo ma valido come fallback
      fallback_pdf = create_fallback_pdf("Errore nella generazione del PDF", 
                                      "Si è verificato un errore durante la generazione del PDF: #{e.message}\nContattare l'amministratore del sistema.")
      return fallback_pdf
    end
  end

  # Prepara l'HTML per la generazione PDF convertendo i percorsi
  def prepare_html_for_pdf(html_string)
    # Rimuovi query parameters dai CSS e immagini
    html_string.gsub!(/href=["']([^:]+\.css\?\d*)["']/i) { |m| 'href="' + $1.split('?').first + '"' }
    html_string.gsub!(/src=["'](\S+\?\d*)["']/i) { |m| 'src="' + $1.split('?').first + '"' }
    
    # Converti percorsi relativi in assoluti per le immagini
    html_string.gsub!(/src=["']([^:]+?)["']/i) { |m| 
      src_path = $1
      if src_path.start_with?('/')
        "src=\"#{RAILS_ROOT}/public#{src_path}\""
      else
        "src=\"#{RAILS_ROOT}/public/#{src_path}\""
      end
    }
    
    # Converti percorsi relativi in assoluti per i CSS
    html_string.gsub!(/href=["']([^:]+\.css)["']/i) { |m| 
      css_path = $1
      if css_path.start_with?('/')
        "href=\"#{RAILS_ROOT}/public#{css_path}\""
      else
        "href=\"#{RAILS_ROOT}/public/#{css_path}\""
      end
    }
    
    # Rimuovi URL malformati
    html_string.gsub!(".com:/",".com/")
    
    # Aggiungi meta tag per wkhtmltopdf se non presente
    if html_string.include?('<head>') && !html_string.include?('charset')
      html_string.gsub!(/<head>/, '<head><meta charset="UTF-8">')
    end
    
    return html_string
  end

  # Crea un PDF minimo ma valido da usare in caso di errore
  def create_fallback_pdf(title, message)
    html = <<-HTML
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <title>#{title}</title>
      <style>
        body { font-family: Arial, sans-serif; margin: 30px; }
        h1 { color: #cc0000; }
        p { margin-top: 20px; }
      </style>
    </head>
    <body>
      <h1>#{title}</h1>
      <p>#{message.gsub("\n", "<br/>")}</p>
    </body>
    </html>
    HTML
    
    # Creare un nuovo oggetto Prince per generare il PDF di fallback
    prince = Princely.new
    result = prince.pdf_from_string(html)
    
    # Se anche questo fallisce, restituisci un PDF vuoto minimo (header + footer)
    unless result && !result.empty? && result.start_with?("%PDF")
      # PDF minimo ma valido
      return "%PDF-1.4\n1 0 obj<</Type/Catalog/Pages 2 0 R>>endobj 2 0 obj<</Type/Pages/Kids[3 0 R]/Count 1>>endobj 3 0 obj<</Type/Page/MediaBox[0 0 595 842]/Parent 2 0 R/Resources<<>>>>endobj\nxref\n0 4\n0000000000 65535 f \n0000000010 00000 n \n0000000053 00000 n \n0000000102 00000 n \ntrailer<</Size 4/Root 1 0 R>>\nstartxref\n178\n%%EOF\n"
    end
    
    return result
  end

  def make_and_send_pdf(pdf_name, options = {})
    send_data(
      make_pdf(options),
      :filename => pdf_name + ".pdf",
      :type => 'application/pdf'
    ) 
  end
  
  def stylesheet_file_path(stylesheet)
    stylesheet = stylesheet.to_s.gsub(".css","")
    File.join(ActionView::Helpers::AssetTagHelper::STYLESHEETS_DIR,"#{stylesheet}.css")
  end
end
