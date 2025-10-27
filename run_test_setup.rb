#!/usr/bin/env ruby

ENV['RAILS_ENV'] ||= 'development'

# Carica l'ambiente Rails
require File.join(File.dirname(__FILE__), 'config', 'environment')

puts "🧪 Creazione dati di test semplificati..."

begin
  # Verifica che esistano già alcuni dati
  rapporti_esistenti = Rapporto.find(:all, :conditions => "numero >= 1000 AND numero <= 1002")
  
  if rapporti_esistenti.size >= 3
    puts "✅ Rapporti di test già esistenti:"
    rapporti_esistenti.each do |r|
      puts "   - Rapporto #{r.numero}/#{r.anno} - Campione: #{r.campione.numero}"
    end
  else
    puts "📋 Creo rapporti di test minimi..."
    
    # Se non ci sono rapporti di test, ne creo alcuni basici usando i dati esistenti
    clienti_esistenti = Cliente.find(:all, :limit => 1)
    matrici_esistenti = Matrice.find(:all, :limit => 1)
    
    if clienti_esistenti.empty? || matrici_esistenti.empty?
      puts "❌ Non ci sono clienti o matrici nel database. Caricare prima i dati base."
      exit 1
    end
    
    cliente = clienti_esistenti.first
    matrice = matrici_esistenti.first
    
    puts "🔧 Uso dati esistenti:"
    puts "   - Cliente: #{cliente.nome}"  
    puts "   - Matrice: #{matrice.nome}"
    
    # Crea un paio di rapporti di test con i dati esistenti
    2.times do |i|
      numero_campione = "TEST-ANTEPRIMA-#{i+1}"
      
      # Cerca campione esistente o creane uno nuovo
      campione = Campione.find_by_numero(numero_campione)
      unless campione
        campione = Campione.create!(
          :numero => numero_campione,
          :etichetta => "Test Anteprima PDF #{i+1}",
          :cliente_id => cliente.id,
          :data => Date.today,
          :anno => Date.today.year
        )
      end
      
      # Cerca rapporto esistente o creane uno nuovo
      rapporto = Rapporto.find_by_numero(1500 + i)
      unless rapporto
        rapporto = Rapporto.create!(
          :numero => 1500 + i,
          :anno => Date.today.year,
          :campione_id => campione.id,
          :data_richiesta => Date.today,
          :completo => true
        )
      end
      
      puts "✅ Creato rapporto #{rapporto.numero}/#{rapporto.anno}"
    end
  end
  
  puts ""
  puts "🎉 DATI DISPONIBILI PER IL TEST!"
  puts ""
  puts "🧪 Per testare l'anteprima PDF:"
  puts "   1. Accedi all'interfaccia web: http://localhost:3000"
  puts "   2. Vai alla sezione admin/ricerca rapporti"  
  puts "   3. Cerca rapporti recenti"
  puts "   4. Seleziona almeno 2-3 rapporti"
  puts "   5. Clicca 'Anteprima Risultati'"
  puts "   6. Aggiungi '.pdf' all'URL per test PDF"
  puts ""

rescue => e
  puts "❌ Errore: #{e.message}"
  puts e.backtrace.first(3).join("\n")
  exit 1
end
