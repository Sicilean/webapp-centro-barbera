#!/usr/bin/env ruby
# Test veloce per verificare che la generazione PDF funzioni
# docker-compose exec web rails runner "load 'test_pdf.rb'"

puts "🧪 TEST GENERAZIONE PDF"
puts "=" * 30

begin
  # Trova un rapporto esistente
  rapporto = Rapporto.find(:first, :conditions => "numero IS NOT NULL AND anno IS NOT NULL", :order => "id DESC")
  
  if rapporto.nil?
    puts "❌ Nessun rapporto completo trovato nel database"
    puts "   Crea prima un rapporto completo con numero e anno"
    exit
  end
  
  puts "✅ Rapporto trovato: RDP #{rapporto.numero}/#{rapporto.anno}"
  puts "   - Cliente: #{rapporto.campione.cliente.nome}" 
  puts "   - Campione: RC #{rapporto.campione.numero}"
  puts "   - Tipologia: #{rapporto.tipologia.nome}"
  
  # Verifica che l'immagine dell'intestazione esista
  intestazione_path = File.join(Rails.root, 'public', 'images', 'rdp_intestazione.jpg')
  if File.exist?(intestazione_path)
    puts "✅ Immagine intestazione trovata (#{File.size(intestazione_path)} bytes)"
  else
    puts "⚠️  Immagine intestazione non trovata: #{intestazione_path}"
  end
  
  # Verifica CSS
  css_rdp = File.join(Rails.root, 'public', 'stylesheets', 'rdp.css')
  css_prince = File.join(Rails.root, 'public', 'stylesheets', 'prince.css')
  css_anteprima = File.join(Rails.root, 'public', 'stylesheets', 'anteprima_risultati.css')
  
  puts "✅ CSS rdp.css: #{File.exist?(css_rdp) ? 'OK' : 'MANCANTE'}"
  puts "✅ CSS prince.css: #{File.exist?(css_prince) ? 'OK' : 'MANCANTE'}"
  puts "✅ CSS anteprima_risultati.css: #{File.exist?(css_anteprima) ? 'OK' : 'MANCANTE'}"
  
  # Test del sistema Princely
  if defined?(Princely)
    puts "✅ Classe Princely caricata"
    
    # Test di generazione HTML
    html_test = %Q{
      <html>
        <head>
          <meta charset="UTF-8">
          <style>
            body { font-family: Arial, sans-serif; margin: 20px; }
            .header { text-align: center; margin-bottom: 20px; }
          </style>
        </head>
        <body>
          <div class="header">
            <img src="#{Rails.root}/public/images/rdp_intestazione.jpg" style="max-width: 100%; width: 70%;" />
            <h1>TEST PDF GENERAZIONE</h1>
          </div>
          <p>Rapporto: RDP #{rapporto.numero}/#{rapporto.anno}</p>
          <p>Cliente: #{rapporto.campione.cliente.nome}</p>
          <p>Data: #{Time.current.strftime("%d/%m/%Y")}</p>
          <p>Questo è un test per verificare che la generazione PDF funzioni correttamente.</p>
        </body>
      </html>
    }
    
    puts "\n🔄 Tentativo di generazione PDF di test..."
    
    begin
      princely = Princely.new
      pdf_result = princely.pdf_from_string(html_test)
      
      if pdf_result && pdf_result.length > 100
        puts "✅ PDF di test generato con successo (#{pdf_result.length} bytes)"
        
        # Salva il PDF di test
        test_file = File.join(Rails.root, 'pdf', 'test_generazione.pdf')
        File.open(test_file, 'wb') { |f| f.write(pdf_result) }
        puts "💾 PDF salvato in: #{test_file}"
      else
        puts "⚠️  PDF di test sembra vuoto o danneggiato"
      end
      
    rescue => e
      puts "❌ Errore durante la generazione PDF: #{e.message}"
    end
    
  else
    puts "❌ Classe Princely NON caricata"
  end
  
  puts "\n" + "=" * 30
  puts "🎯 ISTRUZIONI PER IL TEST:"
  puts "1. Vai su http://localhost:3000/admin"
  puts "2. Cerca il rapporto RDP #{rapporto.numero}/#{rapporto.anno}"
  puts "3. Clicca su 'Crea RDP' o 'Mostra RDP'"
  puts "4. Verifica che il PDF contenga:"
  puts "   - L'intestazione con logo Centro Enochimico Barbera"
  puts "   - I dati del rapporto"
  puts "   - La firma del responsabile"
  puts "   - Il piè di pagina con le autorizzazioni"
  
  puts "\n💡 Se il PDF è ancora vuoto, controlla i log in:"
  puts "   - log/development.log"
  puts "   - log/prince.log"
  
rescue => e
  puts "❌ ERRORE: #{e.message}"
  puts e.backtrace[0..3].join("\n")
end
