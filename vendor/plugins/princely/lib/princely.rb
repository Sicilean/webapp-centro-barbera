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

  def initialize()
    @exe_path = find_executable
  	@style_sheets = ''
  	@log_file = "#{RAILS_ROOT}/log/prince.log"
  	@logger = RAILS_DEFAULT_LOGGER
  end
  
  def add_style_sheets(*sheets)
    for sheet in sheets do
      @style_sheets << " -s #{sheet} "
    end
  end
  
  # Builds the full command for PDF generation.
  # Returns a NEW string each time — never mutates @exe_path.
  def build_pdf_command(output_file = nil)
    cmd = @exe_path.to_s.dup
    cmd += " --input=html --server --log=#{@log_file} "
    cmd += @style_sheets.to_s
    if output_file
      cmd += " --silent - -o '#{output_file}' >> '#{@log_file}' 2>> '#{@log_file}'"
    else
      cmd += " --silent - -o -"
    end
    cmd
  end
  
  # Makes a PDF from a passed in string.
  # The HTML should already have paths converted by the caller (pdf_helper).
  def pdf_from_string(string, output_file = '-')
    if @exe_path.nil? || @exe_path.to_s.strip.empty? || !command_available?
      logger.info "Prince/wkhtmltopdf non disponibile, usando fallback nativo Ruby"
      return generate_pdf_fallback(string)
    end
    
    path = build_pdf_command
    
    logger.info "\n\nPRINCE XML PDF COMMAND"
    logger.info path
    logger.info ''
    
    begin
      if string.nil? || string.empty? || !string.include?('<html')
        logger.error "PRINCE ERROR: Input HTML non valido o vuoto"
        return generate_pdf_fallback(string)
      end
      
      pdf = IO.popen(path, "w+")
      pdf.puts(string)
      pdf.close_write
      result = pdf.gets(nil)
      pdf.close_read
      
      if result.nil? || result.empty? || !result.start_with?("%PDF")
        logger.error "PRINCE ERROR: Output non valido o non e' un PDF"
        logger.error "HTML input length: #{string.length} bytes"
        logger.error "HTML input preview: #{string[0..200]}..."
        return generate_pdf_fallback(string)
      end
      
      if result.length < 200
        logger.error "PRINCE ERROR: PDF troppo piccolo (#{result.length} byte)"
        return generate_pdf_fallback(string)
      end
      
      return result
    rescue => e
      logger.error "PRINCE ERROR: #{e.message}"
      logger.error e.backtrace.join("\n")
      return generate_pdf_fallback(string)
    end
  end

  def pdf_from_string_to_file(string, output_file)
    if @exe_path.nil? || @exe_path.to_s.strip.empty? || !command_available?
      logger.info "Prince/wkhtmltopdf non disponibile per file, usando fallback"
      pdf_content = generate_pdf_fallback(string)
      if pdf_content
        File.open(output_file, 'wb') { |f| f.write(pdf_content) }
        return true
      end
      return false
    end
    
    path = build_pdf_command
    
    logger.info "\n\nPRINCE XML PDF COMMAND (to file)"
    logger.info path
    logger.info ''
    
    begin
      pdf = IO.popen(path, "w+")
      pdf.puts(string)
      pdf.close_write
      result = pdf.gets(nil)
      pdf.close_read
      
      if result && !result.empty? && result.start_with?("%PDF") && result.length >= 200
        File.open(output_file, 'wb') { |f| f.write(result) }
        return true
      else
        logger.error "PRINCE ERROR: Output non valido per file #{output_file}"
        pdf_content = generate_pdf_fallback(string)
        if pdf_content
          File.open(output_file, 'wb') { |f| f.write(pdf_content) }
          return true
        end
        return false
      end
    rescue => e
      logger.error "PRINCE ERROR: #{e.message}"
      logger.error e.backtrace.join("\n")
      pdf_content = generate_pdf_fallback(string)
      if pdf_content
        File.open(output_file, 'wb') { |f| f.write(pdf_content) }
        return true
      end
      return false
    end
  end

  private

  def find_executable
    exe = ''
    
    exe = `which prince 2>/dev/null`.chomp rescue ''
    
    if exe.empty?
      exe = `which prince_wrapper.sh 2>/dev/null`.chomp rescue ''
    end
    
    if exe.empty?
      local_wrapper = File.join(RAILS_ROOT, 'prince_wrapper.sh')
      exe = local_wrapper if File.exist?(local_wrapper)
    end
    
    # wkhtmltopdf diretto: ha bisogno di xvfb-run per X11 headless
    if exe.empty?
      wk = `which wkhtmltopdf 2>/dev/null`.chomp rescue ''
      exe = "xvfb-run -a #{wk}" unless wk.empty?
    end
    
    exe
  end

  def command_available?
    return false if @exe_path.nil? || @exe_path.to_s.strip.empty?
    
    cmd = @exe_path.to_s.split(' ').first
    return false if cmd.nil? || cmd.empty?
    
    if RUBY_PLATFORM =~ /mswin|mingw|cygwin/
      return File.exist?(cmd)
    else
      File.executable?(cmd) || (system("which #{cmd} > /dev/null 2>&1") rescue false)
    end
  end

  def generate_pdf_fallback(html_string)
    logger.info "Generazione PDF fallback nativo Ruby"
    
    begin
      text_content = extract_text_from_html(html_string)
      pdf_content = create_simple_pdf(text_content)
      
      logger.info "PDF fallback generato (#{pdf_content.length} byte)"
      return pdf_content
    rescue => e
      logger.error "Errore PDF fallback: #{e.message}"
      return create_minimal_pdf("Errore nella generazione del PDF")
    end
  end

  def extract_text_from_html(html)
    return "Contenuto non disponibile" if html.nil? || html.empty?
    
    text = html.gsub(/<script[^>]*>.*?<\/script>/mi, '')
    text = text.gsub(/<style[^>]*>.*?<\/style>/mi, '')
    
    text = text.gsub(/<br\s*\/?>/i, "\n")
    text = text.gsub(/<\/p>/i, "\n\n")
    text = text.gsub(/<\/div>/i, "\n")
    text = text.gsub(/<\/h[1-6]>/i, "\n\n")
    text = text.gsub(/<\/tr>/i, "\n")
    text = text.gsub(/<\/td>/i, "  |  ")
    text = text.gsub(/<\/th>/i, "  |  ")
    
    text = text.gsub(/<[^>]+>/, '')
    
    text = text.gsub(/&amp;/, '&')
    text = text.gsub(/&lt;/, '<')
    text = text.gsub(/&gt;/, '>')
    text = text.gsub(/&quot;/, '"')
    text = text.gsub(/&#(\d+);/) { $1.to_i.chr rescue '' }
    text = text.gsub(/&[a-zA-Z]+;/, '')
    
    text = text.gsub(/[ \t]+/, ' ')
    text = text.gsub(/\n\s*\n\s*\n+/, "\n\n")
    text = text.strip
    
    return text.empty? ? "Contenuto non disponibile" : text
  end

  # Crea un PDF valido con testo posizionato correttamente.
  # Usa Td relativo: prima riga con posizione assoluta, successive con offset (0, -leading).
  def create_simple_pdf(text_content)
    leading = 13
    font_size = 9
    margin_left = 40
    margin_top = 780
    margin_bottom = 40
    max_line_len = 105
    
    lines = text_content.to_s.split("\n")
    
    content_stream = ""
    content_stream += "BT\n"
    content_stream += "/F1 #{font_size} Tf\n"
    content_stream += "#{margin_left} #{margin_top} Td\n"
    
    y_position = margin_top
    
    lines.each_with_index do |line, idx|
      break if y_position < margin_bottom
      
      line = line[0..(max_line_len - 1)] + "..." if line.to_s.length > max_line_len
      
      escaped = line.to_s
        .gsub('\\', '\\\\\\\\')
        .gsub('(', '\\(')
        .gsub(')', '\\)')
      
      content_stream += "0 -#{leading} Td\n" if idx > 0
      content_stream += "(#{escaped}) Tj\n"
      y_position -= leading
    end
    
    content_stream += "ET\n"
    
    pdf = "%PDF-1.4\n"
    
    catalog_offset = pdf.length
    pdf += "1 0 obj\n<< /Type /Catalog /Pages 2 0 R >>\nendobj\n"
    
    pages_offset = pdf.length
    pdf += "2 0 obj\n<< /Type /Pages /Kids [3 0 R] /Count 1 >>\nendobj\n"
    
    content_offset = pdf.length
    pdf += "4 0 obj\n<< /Length #{content_stream.length} >>\nstream\n#{content_stream}endstream\nendobj\n"
    
    font_offset = pdf.length
    pdf += "5 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>\nendobj\n"
    
    page_offset = pdf.length
    pdf += "3 0 obj\n<< /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] /Resources << /Font << /F1 5 0 R >> >> /Contents 4 0 R >>\nendobj\n"
    
    xref_offset = pdf.length
    pdf += "xref\n"
    pdf += "0 6\n"
    pdf += "0000000000 65535 f \n"
    pdf += sprintf("%010d 00000 n \n", catalog_offset)
    pdf += sprintf("%010d 00000 n \n", pages_offset)
    pdf += sprintf("%010d 00000 n \n", page_offset)
    pdf += sprintf("%010d 00000 n \n", content_offset)
    pdf += sprintf("%010d 00000 n \n", font_offset)
    
    pdf += "trailer\n"
    pdf += "<< /Size 6 /Root 1 0 R >>\n"
    pdf += "startxref\n"
    pdf += "#{xref_offset}\n"
    pdf += "%%EOF\n"
    
    return pdf
  end

  def create_minimal_pdf(error_message)
    content = "ERRORE: #{error_message}\n\nImpossibile generare il PDF.\nContattare l'amministratore del sistema."
    return create_simple_pdf(content)
  end
end
