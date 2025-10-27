#!/usr/bin/env ruby

ENV['RAILS_ENV'] ||= 'development'
require File.join(File.dirname(__FILE__), 'config', 'environment')

puts "🔍 Verifica dati esistenti..."

begin
  # Conta rapporti esistenti
  rapporti_count = Rapporto.count
  puts "📊 Rapporti totali: #{rapporti_count}"
  
  if rapporti_count > 0
    puts "✅ Primi 5 rapporti esistenti:"
    Rapporto.find(:all, :limit => 5).each do |r|
      cliente_nome = r.campione && r.campione.cliente ? r.campione.cliente.nome : 'N/A'
      etichetta = r.campione ? r.campione.etichetta : 'N/A'
      puts "   - Rapporto #{r.numero}/#{r.anno} - Cliente: #{cliente_nome} - #{etichetta}"
    end
    
    puts ""
    puts "🧪 DATI SUFFICIENTI PER IL TEST!"
    puts "Puoi testare l'anteprima PDF con i rapporti esistenti:"
    puts "1. Accedi all'interfaccia web: http://localhost:3000"
    puts "2. Vai alla sezione admin → Ricerca Rapporti"  
    puts "3. Seleziona alcuni rapporti esistenti"
    puts "4. Clicca 'Anteprima Risultati'"
    puts "5. Aggiungi '.pdf' all'URL per testare la generazione PDF"
    puts ""
  else
    puts "❌ Nessun rapporto trovato nel database"
    puts "   Carica prima i dati con gli script di import"
  end

rescue => e
  puts "❌ Errore: #{e.message}"
end

