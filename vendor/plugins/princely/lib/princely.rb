# PrinceXML Ruby interface. 
# http://www.princexml.com
#
# Library by Subimage Interactive - http://www.subimage.com
#
#
# USAGE
# -----------------------------------------------------------------------------
#   princely = Princely.new()
#   html_string = render_to_string(:template => 'some_document')
#   send_data(
#     princely.pdf_from_string(html_string),
#     :filename => 'some_document.pdf'
#     :type => 'application/pdf'
#   )
#
$:.unshift(File.dirname(__FILE__))
require 'logger'

class Princely
  VERSION = "1.0.0" unless const_defined?("VERSION")
  
  attr_accessor :exe_path, :style_sheets, :log_file, :logger

  # Initialize method
  #
  def initialize()
    # Finds where the application lives, so we can call it.
    @exe_path = `which prince`.chomp
    
    # Se prince non è trovato, prova a cercare il wrapper
    if @exe_path.length == 0
      @exe_path = `which prince_wrapper.sh`.chomp
      if @exe_path.length == 0
        # Prova a usare il wrapper locale
        @exe_path = File.join(RAILS_ROOT, 'prince_wrapper.sh')
        if !File.exist?(@exe_path)
          raise "Cannot find prince command-line app or prince_wrapper.sh in $PATH"
        end
      end
    end
    
    # Se stiamo usando wkhtmltopdf, aggiungi xvfb-run per X11
    if @exe_path.include?('wkhtmltopdf') || `#{@exe_path} --version 2>&1`.include?('wkhtmltopdf')
      @exe_path = "xvfb-run -a #{@exe_path}"
    end
    
  	@style_sheets = ''
  	@log_file = "#{RAILS_ROOT}/log/prince.log"
  	@logger = RAILS_DEFAULT_LOGGER
  end
  
  # Sets stylesheets...
  # Can pass in multiple paths for css files.
  #
  def add_style_sheets(*sheets)
    for sheet in sheets do
      @style_sheets << " -s #{sheet} "
    end
  end
  
  # Returns fully formed executable path with any command line switches
  # we've set based on our variables.
  #
  def exe_path
    # Add any standard cmd line arguments we need to pass
    @exe_path << " --input=html --server --log=#{@log_file} "
    @exe_path << @style_sheets
    return @exe_path
  end
  
  # Makes a pdf from a passed in string.
  #
  # Returns PDF as a stream, so we can use send_data to shoot
  # it down the pipe using Rails.
  #
  def pdf_from_string(string, output_file = '-')
    # Se Prince non è disponibile, usa il fallback nativo
    if @exe_path.nil? || @exe_path.empty? || !command_available?(@exe_path.split(' ').first)
      logger.info "Prince/wkhtmltopdf non disponibile, usando fallback nativo Ruby"
      return generate_pdf_fallback(string)
    end
    
    path = self.exe_path()
    # Don't spew errors to the standard out...and set up to take IO 
    # as input and output
    path << ' --silent - -o -'
    
    # Show the command used...
    logger.info "\n\nPRINCE XML PDF COMMAND"
    logger.info path
    logger.info ''
    
    begin
      # Controlla se l'input è valido prima di inviarlo a Prince
      if string.nil? || string.empty? || !string.include?('<html')
        logger.error "PRINCE ERROR: Input HTML non valido o vuoto"
        return generate_pdf_fallback(string)
      end
      
      # Prepara l'HTML per wkhtmltopdf
      html_string = prepare_html_for_wkhtmltopdf(string)
      
      # Actually call the prince command, and pass the entire data stream back.
      pdf = IO.popen(path, "w+")
      pdf.puts(html_string)
      pdf.close_write
      result = pdf.gets(nil)
      pdf.close_read
      
      # Verifica se il risultato è un PDF valido
      if result.nil? || result.empty? || !result.start_with?("%PDF")
        logger.error "PRINCE ERROR: Output is nil, empty or not a valid PDF, usando fallback"
        logger.error "HTML input length: #{html_string.length} bytes"
        # Scrivi gli ultimi 100 caratteri di string nei log per debug
        logger.error "HTML input preview: #{html_string[0..100]}..."
        return generate_pdf_fallback(string)
      end
      
      # Verifica che il PDF contenga almeno la struttura minima
      if result.length < 200
        logger.error "PRINCE ERROR: PDF troppo piccolo, usando fallback. Dimensione: #{result.length} byte"
        return generate_pdf_fallback(string)
      end
      
      return result
    rescue => e
      logger.error "PRINCE ERROR: Exception during PDF generation: #{e.message}, usando fallback"
      logger.error e.backtrace.join("\n")
      return generate_pdf_fallback(string)
    end
  end

  def pdf_from_string_to_file(string, output_file)
    # Se Prince non è disponibile, usa il fallback nativo
    if @exe_path.nil? || @exe_path.empty? || !command_available?(@exe_path.split(' ').first)
      logger.info "Prince/wkhtmltopdf non disponibile, usando fallback nativo Ruby per file"
      pdf_content = generate_pdf_fallback(string)
      if pdf_content
        File.open(output_file, 'wb') { |f| f.write(pdf_content) }
        return true
      else
        return false
      end
    end
    
    path = self.exe_path()
    # Don't spew errors to the standard out...and set up to take IO 
    # as input and output
    path << " --silent - -o '#{output_file}' >> '#{@log_file}' 2>> '#{@log_file}'"
    
    # Show the command used...
    logger.info "\n\nPRINCE XML PDF COMMAND"
    logger.info path
    logger.info ''
    
    begin
      # Prepara l'HTML per wkhtmltopdf
      html_string = prepare_html_for_wkhtmltopdf(string)
      
      # Actually call the prince command, and pass the entire data stream back.
      pdf = IO.popen(path, "w+")
      pdf.puts(html_string)
      pdf.close
      
      # Verifica che il file sia stato creato e sia un PDF valido
      if !File.exist?(output_file) || File.size(output_file) < 10
        logger.error "PRINCE ERROR: File output is missing or too small, usando fallback: #{output_file}"
        logger.error "HTML input length: #{html_string.length} bytes"
        # Scrivi gli ultimi 100 caratteri di string nei log per debug
        logger.error "HTML input preview: #{html_string[0..100]}..."
        
        # Usa il fallback per salvare il file
        pdf_content = generate_pdf_fallback(string)
        if pdf_content
          File.open(output_file, 'wb') { |f| f.write(pdf_content) }
          return true
        else
          return false
        end
      end
      
      return true
    rescue => e
      logger.error "PRINCE ERROR: Exception during PDF generation to file: #{e.message}, usando fallback"
      logger.error e.backtrace.join("\n")
      
      # Usa il fallback per salvare il file
      pdf_content = generate_pdf_fallback(string)
      if pdf_content
        File.open(output_file, 'wb') { |f| f.write(pdf_content) }
        return true
      else
        return false
      end
    end
  end

  private

  # Verifica se un comando è disponibile nel sistema
  def command_available?(command)
    return false if command.nil? || command.empty?
    
    # Rimuovi eventuali parametri dal comando
    cmd = command.split(' ').first
    
    # Su Windows, controlla se il file esiste
    if RUBY_PLATFORM =~ /mswin|mingw|cygwin/
      # Cerca nel PATH
      ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
        exe = File.join(path, "#{cmd}.exe")
        return true if File.executable?(exe)
      end
      return false
    else
      # Su Unix/Linux usa which
      system("which #{cmd} > /dev/null 2>&1")
    end
  end

  # Genera un PDF usando solo Ruby (fallback quando Prince non è disponibile)
  def generate_pdf_fallback(html_string)
    logger.info "Generazione PDF fallback nativo Ruby"
    
    begin
      # Estrai il contenuto testuale dall'HTML
      text_content = extract_text_from_html(html_string)
      
      # Crea un PDF semplice ma valido
      pdf_content = create_simple_pdf(text_content)
      
      logger.info "PDF fallback generato con successo (#{pdf_content.length} byte)"
      return pdf_content
      
    rescue => e
      logger.error "Errore durante la generazione PDF fallback: #{e.message}"
      # Restituisci un PDF minimo ma valido
      return create_minimal_pdf("Errore nella generazione del PDF")
    end
  end

  # Estrae il testo dall'HTML rimuovendo i tag
  def extract_text_from_html(html)
    return "Contenuto non disponibile" if html.nil? || html.empty?
    
    # Controlla se l'HTML contiene solo l'intestazione e il piè di pagina (anteprima vuota)
    if html.include?('anteprima_risultati') && 
       html.scan(/<tr>/).size <= 2 && # Solo header della tabella
       html.include?('width = \'35%\'') # Intestazione tipica
      
      return "ANTEPRIMA RISULTATI\n\n" +
             "L'anteprima risulta vuota.\n\n" +
             "Possibili cause:\n" +
             "- Il rapporto selezionato non ha prove associate\n" +
             "- Le prove non hanno variabili definite\n" +
             "- I dati non sono stati inseriti completamente\n\n" +
             "Verificare che il rapporto sia completo e contenga dati di analisi.\n\n" +
             "Per assistenza contattare l'amministratore del sistema."
    end
    
    # Rimuovi script e style
    text = html.gsub(/<script[^>]*>.*?<\/script>/mi, '')
    text = text.gsub(/<style[^>]*>.*?<\/style>/mi, '')
    
    # Converti alcuni tag in testo leggibile
    text = text.gsub(/<br\s*\/?>/i, "\n")
    text = text.gsub(/<\/p>/i, "\n\n")
    text = text.gsub(/<\/div>/i, "\n")
    text = text.gsub(/<\/h[1-6]>/i, "\n\n")
    text = text.gsub(/<\/tr>/i, "\n")
    text = text.gsub(/<\/td>/i, " | ")
    text = text.gsub(/<\/th>/i, " | ")
    
    # Rimuovi tutti i tag HTML rimanenti
    text = text.gsub(/<[^>]+>/, '')
    
    # Decodifica entità HTML comuni
    text = text.gsub(/&amp;/, '&')
    text = text.gsub(/&lt;/, '<')
    text = text.gsub(/&gt;/, '>')
    text = text.gsub(/&quot;/, '"')
    text = text.gsub(/&#(\d+);/) { $1.to_i.chr }
    
    # Pulisci spazi multipli e righe vuote eccessive
    text = text.gsub(/[ \t]+/, ' ')
    text = text.gsub(/\n\s*\n\s*\n+/, "\n\n")
    text = text.strip
    
    return text.empty? ? "Contenuto non disponibile" : text
  end

  # Crea un PDF semplice con il contenuto testuale
  def create_simple_pdf(text_content)
    # Header PDF
    pdf = "%PDF-1.4\n"
    
    # Catalogo (oggetto 1)
    catalog_obj = "1 0 obj\n<< /Type /Catalog /Pages 2 0 R >>\nendobj\n"
    catalog_offset = pdf.length
    pdf += catalog_obj
    
    # Pagine (oggetto 2)
    pages_obj = "2 0 obj\n<< /Type /Pages /Kids [3 0 R] /Count 1 >>\nendobj\n"
    pages_offset = pdf.length
    pdf += pages_obj
    
    # Contenuto della pagina
    lines = text_content.split("\n")
    content_stream = ""
    y_position = 750
    
    content_stream += "BT\n"
    content_stream += "/F1 12 Tf\n"
    
    lines.each do |line|
      break if y_position < 50  # Non andare sotto il margine
      
      # Limita la lunghezza delle righe
      if line.length > 80
        line = line[0..77] + "..."
      end
      
      # Escape caratteri speciali
      escaped_line = line.gsub(/[()\\]/) { |char| "\\#{char}" }
      
      content_stream += "50 #{y_position} Td\n"
      content_stream += "(#{escaped_line}) Tj\n"
      y_position -= 15
    end
    
    content_stream += "ET\n"
    
    # Oggetto contenuto (oggetto 4)
    content_obj = "4 0 obj\n<< /Length #{content_stream.length} >>\nstream\n#{content_stream}\nendstream\nendobj\n"
    content_offset = pdf.length
    pdf += content_obj
    
    # Font (oggetto 5)
    font_obj = "5 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>\nendobj\n"
    font_offset = pdf.length
    pdf += font_obj
    
    # Pagina (oggetto 3)
    page_obj = "3 0 obj\n<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] /Resources << /Font << /F1 5 0 R >> >> /Contents 4 0 R >>\nendobj\n"
    page_offset = pdf.length
    pdf += page_obj
    
    # Tabella xref
    xref_offset = pdf.length
    pdf += "xref\n"
    pdf += "0 6\n"
    pdf += "0000000000 65535 f \n"
    pdf += sprintf("%010d 00000 n \n", catalog_offset)
    pdf += sprintf("%010d 00000 n \n", pages_offset)
    pdf += sprintf("%010d 00000 n \n", page_offset)
    pdf += sprintf("%010d 00000 n \n", content_offset)
    pdf += sprintf("%010d 00000 n \n", font_offset)
    
    # Trailer
    pdf += "trailer\n"
    pdf += "<< /Size 6 /Root 1 0 R >>\n"
    pdf += "startxref\n"
    pdf += "#{xref_offset}\n"
    pdf += "%%EOF\n"
    
    return pdf
  end

  # Crea un PDF minimo in caso di errore critico
  def create_minimal_pdf(error_message)
    content = "ERRORE: #{error_message}\n\nImpossibile generare il PDF completo.\nContattare l'amministratore del sistema."
    return create_simple_pdf(content)
  end

  # Prepara l'HTML per wkhtmltopdf convertendo i percorsi e aggiustando la formattazione
  def prepare_html_for_wkhtmltopdf(html_string)
    # Rimuovi query parameters dai CSS
    html_string.gsub!(/href=["']([^:]+\.css\?\d*)["']/i) { |m| 'href="' + $1.split('?').first + '"' }
    
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
    
    # Aggiungi meta tag per wkhtmltopdf
    if html_string.include?('<head>')
      html_string.gsub!(/<head>/, '<head><meta charset="UTF-8">')
    end
    
    return html_string
  end
end