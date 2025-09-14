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
        return nil
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
        logger.error "PRINCE ERROR: Output is nil, empty or not a valid PDF"
        logger.error "HTML input length: #{html_string.length} bytes"
        # Scrivi gli ultimi 100 caratteri di string nei log per debug
        logger.error "HTML input preview: #{html_string[0..100]}..."
        return nil
      end
      
      # Verifica che il PDF contenga almeno la struttura minima
      if result.length < 200
        logger.error "PRINCE ERROR: PDF troppo piccolo, probabilmente non valido. Dimensione: #{result.length} byte"
        return nil
      end
      
      return result
    rescue => e
      logger.error "PRINCE ERROR: Exception during PDF generation: #{e.message}"
      logger.error e.backtrace.join("\n")
      return nil
    end
  end

  def pdf_from_string_to_file(string, output_file)
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
        logger.error "PRINCE ERROR: File output is missing or too small: #{output_file}"
        logger.error "HTML input length: #{html_string.length} bytes"
        # Scrivi gli ultimi 100 caratteri di string nei log per debug
        logger.error "HTML input preview: #{html_string[0..100]}..."
        return false
      end
      
      return true
    rescue => e
      logger.error "PRINCE ERROR: Exception during PDF generation to file: #{e.message}"
      logger.error e.backtrace.join("\n")
      return false
    end
  end

  private

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