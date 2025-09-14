#!/usr/bin/env ruby

# Script per testare la generazione PDF
# Per eseguire questo script:
#
# 1. Entrare nella console dell'ambiente desiderato:
#    script/console
#
# 2. Caricare lo script:
#    load File.join(RAILS_ROOT, 'test_pdf_generation.rb')
#
# 3. Eseguire il test:
#    test_pdf_generation

require 'fileutils'

def test_pdf_generation
  puts "=== TEST GENERAZIONE PDF ==="
  puts "Inizio test alle #{Time.now}"
  
  # Verifica che la directory PDF esista
  pdf_dir = File.join(RAILS_ROOT, 'pdf')
  unless File.directory?(pdf_dir)
    FileUtils.mkdir_p(pdf_dir)
    puts "✓ Creata directory PDF: #{pdf_dir}"
  else
    puts "✓ Directory PDF esistente: #{pdf_dir}"
  end
  
  # Verifica che il wrapper prince esista
  prince_wrapper = File.join(RAILS_ROOT, 'prince_wrapper.sh')
  if File.exist?(prince_wrapper)
    puts "✓ Wrapper prince trovato: #{prince_wrapper}"
  else
    puts "✗ Wrapper prince non trovato: #{prince_wrapper}"
    return false
  end
  
  # Verifica che i CSS esistano
  rdp_css = File.join(RAILS_ROOT, 'public', 'stylesheets', 'rdp.css')
  prince_css = File.join(RAILS_ROOT, 'public', 'stylesheets', 'prince.css')
  
  if File.exist?(rdp_css)
    puts "✓ CSS rdp trovato: #{rdp_css}"
  else
    puts "✗ CSS rdp non trovato: #{rdp_css}"
  end
  
  if File.exist?(prince_css)
    puts "✓ CSS prince trovato: #{prince_css}"
  else
    puts "✗ CSS prince non trovato: #{prince_css}"
  end
  
  # Trova un rapporto di test
  rapporto = Rapporto.first(:conditions => ["numero IS NOT NULL AND anno IS NOT NULL"])
  
  if rapporto.nil?
    puts "✗ Nessun rapporto trovato per il test"
    return false
  end
  
  puts "✓ Rapporto di test trovato: ##{rapporto.numero}/#{rapporto.anno}"
  
  # Testa la generazione PDF
  begin
    puts "Inizio generazione PDF per rapporto ##{rapporto.numero}/#{rapporto.anno}..."
    
    # Crea un controller temporaneo per il test
    controller = RapportiController.new
    controller.params = {:id => rapporto.id}
    
    # Simula la generazione PDF
    controller.instance_variable_set(:@rapporto, rapporto)
    controller.instance_variable_set(:@codice_senza_render, true)
    
    # Prepara i dati come nel metodo rdp
    rapporto.aggiorna_data_di_stampa_se_mancante
    controller.instance_variable_set(:@variabile_rapporto_items, rapporto.variabile_rapporto_items.clone)
    controller.instance_variable_set(:@prove_totali, rapporto.prove_totali_ordinate.clone)
    
    # Genera il PDF
    pdf_data = controller.make_pdf(:template => "rapporti/rdp.erb", :pdf => "rdp", :stylesheets => ["rdp", "prince"], :layout => "rdp")
    
    if pdf_data.nil? || pdf_data.empty?
      puts "✗ PDF generato vuoto o nil"
      return false
    end
    
    if !pdf_data.start_with?("%PDF")
      puts "✗ PDF generato non valido (non inizia con %PDF)"
      puts "Primi 100 caratteri: #{pdf_data[0..100]}"
      return false
    end
    
    puts "✓ PDF generato con successo (#{pdf_data.length} byte)"
    
    # Salva il PDF di test
    test_file = File.join(pdf_dir, "test_rapporto_#{rapporto.id}.pdf")
    File.open(test_file, 'wb') do |f|
      f.write(pdf_data)
    end
    
    if File.exist?(test_file) && File.size(test_file) > 100
      puts "✓ PDF salvato con successo: #{test_file}"
      puts "✓ Dimensione file: #{File.size(test_file)} byte"
    else
      puts "✗ Errore nel salvataggio del PDF"
      return false
    end
    
    puts "=== TEST COMPLETATO CON SUCCESSO ==="
    return true
    
  rescue => e
    puts "✗ Errore durante la generazione PDF: #{e.message}"
    puts "Backtrace: #{e.backtrace.join("\n")}"
    return false
  end
end

# Esegui il test se lo script viene chiamato direttamente
if __FILE__ == $0
  test_pdf_generation
end
