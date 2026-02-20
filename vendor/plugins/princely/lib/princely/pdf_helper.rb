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
    
    valid_stylesheets = options[:stylesheets].select do |style|
      css_path = stylesheet_file_path(style)
      File.exist?(css_path)
    end
    
    prince_css_path = stylesheet_file_path('prince')
    unless valid_stylesheets.include?('prince')
      valid_stylesheets << 'prince' if File.exist?(prince_css_path)
    end
    
    prince.add_style_sheets(*valid_stylesheets.collect{|style| stylesheet_file_path(style)})
    
    begin
      @rendering_pdf = true
      html_string = render_to_string(:template => options[:template], :layout => options[:layout])
      @rendering_pdf = false
      
      html_string = prepare_html_for_pdf(html_string)
      
      File.open("#{RAILS_ROOT}/log/last_pdf_html.html", "w") { |f| f.write(html_string) }
      
      pdf_data = if filename = options[:filename] || options[:file]
        prince.pdf_from_string_to_file(html_string, filename)
      else
        prince.pdf_from_string(html_string)
      end
      
      if pdf_data.nil? || (pdf_data.is_a?(String) && (pdf_data.empty? || !pdf_data.start_with?("%PDF")))
        logger.error "ERRORE PDF: output non valido per template #{options[:template]}"
        logger.error "Stylesheets: #{valid_stylesheets.inspect}"
        return create_fallback_pdf("Errore nella generazione del PDF", 
                                "Si e' verificato un errore durante la generazione del PDF.\nContattare l'amministratore del sistema.")
      end
      
      return pdf_data
    rescue => e
      @rendering_pdf = false
      logger.error "ERRORE RENDER PDF: #{e.message}"
      logger.error e.backtrace.join("\n")
      
      return create_fallback_pdf("Errore nella generazione del PDF", 
                              "Errore: #{e.message}\nContattare l'amministratore del sistema.")
    end
  end

  def prepare_html_for_pdf(html_string)
    html_string.gsub!(/href=["']([^:]+\.css)\?\d*["']/i) { |m| 'href="' + $1 + '"' }
    html_string.gsub!(/src=["'](\S+)\?\d*["']/i) { |m| 'src="' + $1 + '"' }
    
    rails_root = RAILS_ROOT
    
    html_string.gsub!(/src=["']([^:"]+?)["']/i) { |m| 
      src_path = $1
      next m if src_path.include?(rails_root)
      if src_path.start_with?('/')
        "src=\"#{rails_root}/public#{src_path}\""
      else
        "src=\"#{rails_root}/public/#{src_path}\""
      end
    }
    
    html_string.gsub!(/href=["']([^:"]+\.css)["']/i) { |m| 
      css_path = $1
      next m if css_path.include?(rails_root)
      if css_path.start_with?('/')
        "href=\"#{rails_root}/public#{css_path}\""
      else
        "href=\"#{rails_root}/public/#{css_path}\""
      end
    }
    
    html_string.gsub!(".com:/",".com/")
    
    if html_string.include?('<head>') && !html_string.include?('charset')
      html_string.gsub!(/<head>/, '<head><meta charset="UTF-8">')
    end
    
    return html_string
  end

  # Fallback PDF: genera direttamente con Ruby, senza riprovare Princely
  def create_fallback_pdf(title, message)
    text = "#{title}\n\n#{message}"
    
    begin
      prince = Princely.new
      prince.send(:create_simple_pdf, text)
    rescue => e
      logger.error "Fallback PDF creation error: #{e.message}" rescue nil
      "%PDF-1.4\n1 0 obj<</Type/Catalog/Pages 2 0 R>>endobj 2 0 obj<</Type/Pages/Kids[3 0 R]/Count 1>>endobj 3 0 obj<</Type/Page/MediaBox[0 0 595 842]/Parent 2 0 R/Resources<<>>>>endobj\nxref\n0 4\n0000000000 65535 f \n0000000010 00000 n \n0000000053 00000 n \n0000000102 00000 n \ntrailer<</Size 4/Root 1 0 R>>\nstartxref\n178\n%%EOF\n"
    end
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
