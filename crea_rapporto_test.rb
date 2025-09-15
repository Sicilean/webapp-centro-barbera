#!/usr/bin/env ruby
# Script per creare un rapporto di prova di test per verificare la generazione PDF
# 
# Per eseguire questo script:
# 1. Aprire la console Rails: docker-compose exec web rails console
# 2. Caricare lo script: load 'crea_rapporto_test.rb'

puts "🧪 CREAZIONE RAPPORTO DI TEST PER PDF"
puts "=" * 50

begin
  # 1. Verifica o crea la matrice di test
  puts "\n🔧 1. Verifica Matrice di Test"
  matrice = Matrice.find_by_nome('Vino') || Matrice.find_by_nome('Test')
  
  if matrice.nil?
    matrice = Matrice.new
    matrice.nome = 'Test'
    matrice.nome_esteso = 'Matrice di Test'
    matrice.save!
    puts "✅ Creata matrice di test: #{matrice.nome}"
  else
    puts "✅ Matrice esistente: #{matrice.nome}"
  end

  # 2. Verifica o crea cliente di test
  puts "\n👤 2. Verifica Cliente di Test"
  cliente = Cliente.find_by_nome('Test Cliente') || Cliente.first
  
  if cliente.nil?
    cliente = Cliente.new
    cliente.nome = 'Test Cliente'
    cliente.denominazione = 'Azienda di Test S.r.l.'
    cliente.indirizzo = 'Via di Test, 123'
    cliente.cap = '91100'
    cliente.comune = 'Trapani'
    cliente.provincia = 'TP'
    cliente.email_per_notifiche = 'test@example.com'
    cliente.save!
    puts "✅ Creato cliente di test: #{cliente.nome}"
  else
    puts "✅ Cliente esistente: #{cliente.nome}"
  end

  # 3. Verifica o crea prova di test
  puts "\n🔬 3. Verifica Prova di Test"
  prova = Prova.find(:first, :conditions => {:matrice_id => matrice.id})
  
  if prova.nil?
    prova = Prova.new
    prova.matrice = matrice
    prova.nome = 'pH'
    prova.nome_esteso = 'Determinazione del pH'
    prova.metodo_di_prova = 'OIV-MA-AS313-15'
    prova.prezzo = 15.00
    prova.save!
    puts "✅ Creata prova di test: #{prova.nome}"
  else
    puts "✅ Prova esistente: #{prova.nome}"
  end

  # 4. Verifica o crea unità di misura
  puts "\n📏 4. Verifica Unità di Misura"
  udm = UdmItem.find_by_nome('pH') || UdmItem.first
  
  if udm.nil?
    udm = UdmItem.new
    udm.nome = 'pH'
    udm.save!
    puts "✅ Creata unità di misura: #{udm.nome}"
  else
    puts "✅ Unità di misura esistente: #{udm.nome}"
  end

  # 5. Verifica o crea variabile di test
  puts "\n📊 5. Verifica Variabile di Test"
  variabile = Variabile.find(:first, :conditions => {:matrice_id => matrice.id, :simbolo => 'pH'})
  
  if variabile.nil?
    variabile = Variabile.new
    variabile.matrice = matrice
    variabile.udm_item = udm
    variabile.nome = 'pH'
    variabile.nome_esteso = 'pH (potenziale idrogeno)'
    variabile.simbolo = 'pH'
    variabile.tipo = 'input'
    variabile.min = 0.0
    variabile.max = 14.0
    variabile.decimali = 2
    variabile.save!
    puts "✅ Creata variabile di test: #{variabile.simbolo}"
  else
    puts "✅ Variabile esistente: #{variabile.simbolo}"
  end

  # 6. Associa variabile alla prova
  puts "\n🔗 6. Associazione Prova-Variabile"
  pvi = ProvaVariabileItem.find(:first, :conditions => {:prova_id => prova.id, :variabile_id => variabile.id})
  
  if pvi.nil?
    pvi = ProvaVariabileItem.new
    pvi.prova = prova
    pvi.variabile = variabile
    pvi.da_mostrare = true
    pvi.save!
    puts "✅ Creata associazione prova-variabile"
  else
    puts "✅ Associazione prova-variabile esistente"
  end

  # 7. Verifica o crea tipologia di test
  puts "\n📋 7. Verifica Tipologia di Test"
  tipologia = Tipologia.find(:first, :conditions => {:matrice_id => matrice.id})
  
  if tipologia.nil?
    tipologia = Tipologia.new
    tipologia.matrice = matrice
    tipologia.nome = 'Analisi Base'
    tipologia.nome_esteso = 'Analisi di Base per Test PDF'
    tipologia.forfeit = true
    tipologia.prezzo = 25.00
    tipologia.sinal = false
    tipologia.pie_pagina = 'Analisi eseguita secondo i metodi ufficiali.'
    tipologia.save!
    puts "✅ Creata tipologia di test: #{tipologia.nome}"
  else
    puts "✅ Tipologia esistente: #{tipologia.nome}"
  end

  # 8. Associa prova alla tipologia
  puts "\n🔗 8. Associazione Tipologia-Prova"
  pti = ProvaTipologiaItem.find(:first, :conditions => {:tipologia_id => tipologia.id, :prova_id => prova.id})
  
  if pti.nil?
    pti = ProvaTipologiaItem.new
    pti.tipologia = tipologia
    pti.prova = prova
    pti.save!
    puts "✅ Creata associazione tipologia-prova"
  else
    puts "✅ Associazione tipologia-prova esistente"
  end

  # 9. Crea campione di test
  puts "\n🧪 9. Creazione Campione di Test"
  
  # Trova il numero successivo per il campione
  ultimo_numero = Campione.maximum(:numero) || 0
  nuovo_numero = ultimo_numero + 1
  
  campione = Campione.new
  campione.cliente = cliente
  campione.numero = nuovo_numero
  campione.anno = Date.current.year
  campione.data = Date.current
  campione.campione_di = 'Vino rosso di test'
  campione.etichetta = 'Campione di test per verifica generazione PDF'
  campione.campionamento = 'Prelievo manuale'
  campione.comune = 'Trapani'
  campione.provincia = 'TP'
  campione.save!
  
  puts "✅ Creato campione di test RC #{campione.numero}/#{campione.anno}"

  # 10. Crea rapporto di test
  puts "\n📄 10. Creazione Rapporto di Test"
  
  # Trova il numero successivo per il rapporto
  ultimo_numero_rdp = Rapporto.where("anno = ?", Date.current.year).maximum(:numero) || 0
  nuovo_numero_rdp = ultimo_numero_rdp + 1
  
  rapporto = Rapporto.new
  rapporto.tipologia = tipologia
  rapporto.campione = campione
  rapporto.numero = nuovo_numero_rdp
  rapporto.anno = Date.current.year
  rapporto.status = 'completo'
  rapporto.data_richiesta = Date.current
  rapporto.data_esecuzione_prove_inizio = Date.current - 1.day
  rapporto.data_stampa = Date.current
  rapporto.prezzo_tipologia_forfeit = 25.00
  rapporto.pie_pagina = 'Rapporto di test generato automaticamente.'
  rapporto.save!
  
  puts "✅ Creato rapporto di test RDP #{rapporto.numero}/#{rapporto.anno}"

  # 11. Crea variabile rapporto item (il risultato)
  puts "\n📊 11. Inserimento Risultato di Test"
  
  vri = VariabileRapportoItem.new
  vri.variabile = variabile
  vri.rapporto = rapporto
  vri.valore_numero = 3.45
  vri.save!
  
  puts "✅ Inserito risultato: pH = 3.45"

  # 12. Crea auto prova rapporto item
  puts "\n🔄 12. Creazione Auto Prova Rapporto Item"
  
  apri = AutoProvaRapportoItem.new
  apri.prova = prova
  apri.rapporto = rapporto
  apri.prezzo = prova.prezzo
  apri.save!
  
  puts "✅ Creato auto prova rapporto item"

  # 13. Riepilogo finale
  puts "\n" + "=" * 50
  puts "🎉 RAPPORTO DI TEST CREATO CON SUCCESSO!"
  puts "=" * 50
  puts "📊 Dettagli del rapporto creato:"
  puts "   - ID Rapporto: #{rapporto.id}"
  puts "   - Numero: RDP #{rapporto.numero}/#{rapporto.anno}"
  puts "   - Cliente: #{cliente.nome}"
  puts "   - Campione: RC #{campione.numero}/#{campione.anno}"
  puts "   - Tipologia: #{tipologia.nome}"
  puts "   - Prova: #{prova.nome}"
  puts "   - Risultato: pH = 3.45"
  
  puts "\n🔗 Link per testare la generazione PDF:"
  puts "   - Anteprima: http://localhost:3000/rapporti/anteprima_risultati?rapporty_array[]=#{rapporto.id}"
  puts "   - PDF Anteprima: http://localhost:3000/rapporti/anteprima_risultati.pdf?rapporty_array[]=#{rapporto.id}"
  puts "   - RDP: http://localhost:3000/rapporti/rdp/#{rapporto.id}"
  puts "   - PDF RDP: http://localhost:3000/rapporti/crea_pdf/#{rapporto.id}"
  
  puts "\n💡 Suggerimenti:"
  puts "   1. Vai su http://localhost:3000/admin/dati_rapporto/#{rapporto.id}"
  puts "   2. Clicca su 'Anteprima' per testare l'anteprima PDF"
  puts "   3. Clicca su 'Crea RDP' per testare il rapporto PDF"
  
  puts "\n✨ Il rapporto è ora pronto per testare la generazione PDF!"

rescue => e
  puts "❌ ERRORE durante la creazione del rapporto di test:"
  puts "   #{e.message}"
  puts "\nStacktrace:"
  puts e.backtrace[0..5].join("\n")
end
