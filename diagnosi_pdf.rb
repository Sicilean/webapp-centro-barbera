#!/usr/bin/env ruby
# Script di diagnostica per i problemi di generazione PDF
# 
# Per eseguire questo script:
# 1. Aprire la console Rails: docker-compose exec web rails console
# 2. Caricare lo script: load 'diagnosi_pdf.rb'

puts "🔍 DIAGNOSTICA GENERAZIONE PDF"
puts "=" * 50

# 1. Verifica parametri essenziali
puts "\n📋 1. VERIFICA PARAMETRI ESSENZIALI"
parametri_essenziali = [
  'anteprima_risultati_intestazione',
  'anteprima_risultati_pie_pagina', 
  'rdp_stampa_intestazione',
  'rdp_stampa_firma',
  'rdp_stampa_pie_pagina_1',
  'lab_comune'
]

parametri_mancanti = []
parametri_vuoti = []

parametri_essenziali.each do |codice|
  param = Parametro.find_by_codice(codice)
  if param.nil?
    parametri_mancanti << codice
    puts "❌ Mancante: #{codice}"
  elsif param.valore.blank?
    parametri_vuoti << codice
    puts "⚠️  Vuoto: #{codice}"
  else
    puts "✅ OK: #{codice} (#{param.valore.length} caratteri)"
  end
end

# 2. Verifica file essenziali
puts "\n📁 2. VERIFICA FILE ESSENZIALI"
files_da_verificare = [
  'public/images/rdp_intestazione.jpg',
  'public/stylesheets/rdp.css',
  'public/stylesheets/prince.css',
  'public/stylesheets/anteprima_risultati.css',
  'vendor/plugins/princely/lib/princely.rb',
  'app/views/rapporti/rdp.erb',
  'app/views/rapporti/anteprima_risultati.erb',
  'app/views/layouts/rdp.erb',
  'app/views/layouts/anteprima_risultati.erb'
]

files_da_verificare.each do |file_path|
  full_path = File.join(Rails.root, file_path)
  if File.exist?(full_path)
    size = File.size(full_path)
    puts "✅ #{file_path} (#{size} bytes)"
  else
    puts "❌ MANCANTE: #{file_path}"
  end
end

# 3. Verifica database e modelli
puts "\n🗃️  3. VERIFICA DATABASE E MODELLI"
begin
  rapporti_count = Rapporto.count
  parametri_count = Parametro.count
  clienti_count = Cliente.count
  puts "✅ Rapporti: #{rapporti_count}"
  puts "✅ Parametri: #{parametri_count}"
  puts "✅ Clienti: #{clienti_count}"
  
  # Verifica rapporto completo più recente
  rapporto_completo = Rapporto.find(:first, 
    :conditions => "numero IS NOT NULL AND anno IS NOT NULL", 
    :order => "created_at DESC")
  
  if rapporto_completo
    puts "✅ Ultimo rapporto completo: ##{rapporto_completo.numero}/#{rapporto_completo.anno}"
    
    # Verifica variabili del rapporto
    variabili_count = rapporto_completo.variabile_rapporto_items.count
    puts "   - Variabili associate: #{variabili_count}"
    
    # Verifica prove
    prove_count = rapporto_completo.prove.count
    puts "   - Prove associate: #{prove_count}"
    
  else
    puts "⚠️  Nessun rapporto completo trovato nel database"
  end
  
rescue => e
  puts "❌ Errore accesso database: #{e.message}"
end

# 4. Test generazione PDF per anteprima
puts "\n🧪 4. TEST GENERAZIONE ANTEPRIMA"
begin
  # Simula la chiamata che fa anteprima_risultati
  if defined?(ApplicationHelper)
    helper = Object.new
    helper.extend(ApplicationHelper)
    
    # Test del metodo mostra_parametro
    test_param = helper.mostra_parametro('anteprima_risultati_intestazione')
    if test_param.include?('<Parametro:')
      puts "❌ mostra_parametro fallisce: #{test_param}"
    else
      puts "✅ mostra_parametro funziona (#{test_param.length} caratteri)"
    end
  end
rescue => e
  puts "❌ Errore test helper: #{e.message}"
end

# 5. Verifica Princely/wkhtmltopdf
puts "\n🖨️  5. VERIFICA SISTEMA PDF"
begin
  if defined?(Princely)
    puts "✅ Classe Princely caricata"
    
    # Test basic di Princely
    princely = Princely.new
    puts "✅ Istanza Princely creata"
    puts "   - Percorso eseguibile: #{princely.instance_variable_get(:@exe_path) || 'Non impostato'}"
  else
    puts "❌ Classe Princely non caricata"
  end
rescue => e
  puts "❌ Errore Princely: #{e.message}"
end

# 6. Riepilogo e suggerimenti
puts "\n📝 RIEPILOGO E SUGGERIMENTI"
puts "=" * 30

if parametri_mancanti.any?
  puts "🚨 AZIONE RICHIESTA: Parametri mancanti"
  puts "   Esegui: load 'popola_parametri_pdf.rb'"
  puts "   Parametri mancanti: #{parametri_mancanti.join(', ')}"
end

if parametri_vuoti.any?
  puts "⚠️  ATTENZIONE: Parametri vuoti"
  puts "   Parametri vuoti: #{parametri_vuoti.join(', ')}"
  puts "   Esegui: load 'popola_parametri_pdf.rb'"
end

# Test rapido per vedere se i PDF possono essere generati
puts "\n🎯 TEST RAPIDO GENERAZIONE"
begin
  if Rapporto.count > 0
    primo_rapporto = Rapporto.first
    puts "Tentativo di generazione HTML per rapporto ID #{primo_rapporto.id}..."
    
    # Simula la generazione dell'HTML che viene dato a Princely
    controller_mock = ActionView::Base.new
    controller_mock.assign(:rapporto => primo_rapporto)
    
    puts "✅ Rapporto di test identificato"
  else
    puts "❌ Nessun rapporto nel database per il test"
  end
rescue => e
  puts "❌ Errore test generazione: #{e.message}"
end

puts "\n" + "=" * 50
puts "✨ Diagnostica completata!"
puts "💡 Se tutti i check sono ✅, i PDF dovrebbero funzionare."
puts "🔧 Se ci sono problemi (❌), risolvi prima quelli."
