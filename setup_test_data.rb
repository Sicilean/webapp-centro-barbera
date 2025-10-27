#!/usr/bin/env ruby

# Script per creare dati di test completi per l'anteprima PDF
# Da eseguire nella console Rails con: load File.join(RAILS_ROOT, 'setup_test_data.rb')

puts "🧪 Creazione dati di test per anteprima PDF..."

begin
  # 1. Crea o verifica cliente di test
  cliente_test = Cliente.find_by_nome("Cliente Test Anteprima") || Cliente.create!(
    :nome => "Cliente Test Anteprima",
    :indirizzo => "Via di Test 123",
    :citta => "Città Test",
    :cap => "12345",
    :provincia => "TP",
    :telefono => "091-123456",
    :fax => "091-123456",
    :email => "test@clientetest.it",
    :partita_iva => "12345678901",
    :codice_fiscale => "TSTCLN80A01A123B",
    :persona_di_riferimento => "Mario Rossi"
  )
  puts "✅ Cliente creato: #{cliente_test.nome}"

  # 2. Crea matrice di test se non esiste
  matrice_test = Matrice.find_by_nome("Vino Test") || Matrice.create!(
    :nome => "Vino Test",
    :descrizione => "Vino per test anteprima PDF"
  )
  puts "✅ Matrice creata: #{matrice_test.nome}"

  # 3. Crea tipologia di test
  tipologia_test = Tipologia.find_by_nome("Analisi Completa Test") || Tipologia.create!(
    :nome => "Analisi Completa Test",
    :descrizione => "Tipologia completa per test anteprima",
    :matrice => matrice_test
  )
  puts "✅ Tipologia creata: #{tipologia_test.nome}"

  # 4. Crea variabili di test
  variabili_test = []
  
  # Alcol
  variabile_alcol = Variabile.find_by_nome("Alcol Test") || Variabile.create!(
    :nome => "Alcol Test",
    :nome_esteso => "Alcol etilico % vol",
    :unita_di_misura => "% vol",
    :posizione_in_rdp => 1
  )
  variabili_test << variabile_alcol

  # Acidità Totale
  variabile_acidita = Variabile.find_by_nome("Acidità Totale Test") || Variabile.create!(
    :nome => "Acidità Totale Test", 
    :nome_esteso => "Acidità totale",
    :unita_di_misura => "g/L",
    :posizione_in_rdp => 2
  )
  variabili_test << variabile_acidita

  # pH
  variabile_ph = Variabile.find_by_nome("pH Test") || Variabile.create!(
    :nome => "pH Test",
    :nome_esteso => "pH",
    :unita_di_misura => "unità pH",
    :posizione_in_rdp => 3
  )
  variabili_test << variabile_ph

  # Zuccheri Riduttori
  variabile_zuccheri = Variabile.find_by_nome("Zuccheri Test") || Variabile.create!(
    :nome => "Zuccheri Test",
    :nome_esteso => "Zuccheri riduttori",
    :unita_di_misura => "g/L",
    :posizione_in_rdp => 4
  )
  variabili_test << variabile_zuccheri

  puts "✅ Variabili create: #{variabili_test.map(&:nome).join(', ')}"

  # 5. Collega variabili alla tipologia
  variabili_test.each do |variabile|
    unless tipologia_test.variabili.include?(variabile)
      ProvaVariabileItem.create!(
        :tipologia => tipologia_test,
        :variabile => variabile,
        :posizione => variabile.posizione_in_rdp || 1
      )
    end
  end
  puts "✅ Variabili collegate alla tipologia"

  # 6. Crea campioni di test
  3.times do |i|
    campione = Campione.find_by_numero("TEST-#{i+1}-#{Date.today.strftime('%Y')}") || Campione.create!(
      :numero => "TEST-#{i+1}-#{Date.today.strftime('%Y')}",
      :etichetta => "Vino Test #{i+1} - Anteprima PDF",
      :cliente => cliente_test,
      :matrice => matrice_test,
      :data_arrivo => Date.today - (i * 2).days,
      :denominazione => "DOC Test #{i+1}",
      :annata => Date.today.year - 1,
      :grado_alcolico => "13.5",
      :note => "Campione di test per anteprima PDF numero #{i+1}"
    )
    
    # 7. Crea rapporti per ogni campione
    rapporto = Rapporto.find_by_numero(1000 + i) || Rapporto.create!(
      :numero => 1000 + i,
      :anno => Date.today.year,
      :campione => campione,
      :data_richiesta => Date.today - (i * 2).days,
      :data_esecuzione_prove_inizio => Date.today - (i * 1).days,
      :data_esecuzione_prove_fine => Date.today - (i * 1).days,
      :completo => true
    )
    
    # 8. Crea prove per ogni rapporto
    prova = Prova.find_by_rapporto_id_and_tipologia_id(rapporto.id, tipologia_test.id) || Prova.create!(
      :rapporto => rapporto,
      :tipologia => tipologia_test,
      :data_esecuzione => Date.today - (i * 1).days,
      :eseguita => true
    )
    
    # 9. Crea valori per ogni variabile
    variabili_test.each_with_index do |variabile, var_idx|
      # Genera valori realistici per ogni variabile
      valore = case variabile.nome
      when /Alcol/
        (12.5 + rand * 2).round(1)  # 12.5-14.5% vol
      when /Acidità/
        (5.5 + rand * 1.5).round(1)  # 5.5-7.0 g/L
      when /pH/
        (3.2 + rand * 0.6).round(2)  # 3.2-3.8
      when /Zuccheri/
        (rand * 5).round(1)  # 0-5 g/L
      else
        (10 + rand * 10).round(1)
      end
      
      unless VariabileRapportoItem.find_by_rapporto_id_and_variabile_id(rapporto.id, variabile.id)
        VariabileRapportoItem.create!(
          :rapporto => rapporto,
          :variabile => variabile,
          :valore_automatico => valore.to_s,
          :valore_manuale => nil
        )
      end
    end
    
    puts "✅ Rapporto #{rapporto.numero}/#{rapporto.anno} creato per campione #{campione.numero}"
  end

  puts ""
  puts "🎉 DATI DI TEST CREATI CON SUCCESSO!"
  puts ""
  puts "📋 Riassunto:"
  puts "   • Cliente: #{cliente_test.nome}"
  puts "   • Campioni: 3 campioni di test"
  puts "   • Rapporti: 1000, 1001, 1002"
  puts "   • Variabili: #{variabili_test.size} variabili per ogni rapporto"
  puts ""
  puts "🧪 Per testare l'anteprima PDF:"
  puts "   1. Vai alla sezione ricerca rapporti"
  puts "   2. Cerca i rapporti 1000-1002"
  puts "   3. Selezionali tutti"
  puts "   4. Genera l'anteprima risultati"
  puts "   5. Scarica in formato PDF"

rescue => e
  puts "❌ Errore durante la creazione dei dati di test:"
  puts e.message
  puts e.backtrace.first(5).join("\n")
end

