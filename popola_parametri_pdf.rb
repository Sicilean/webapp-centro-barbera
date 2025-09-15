#!/usr/bin/env ruby
# Script per popolare i parametri necessari alla generazione dei PDF
# 
# Per eseguire questo script:
# 1. Aprire la console Rails: docker-compose exec web rails console
# 2. Caricare lo script: load 'popola_parametri_pdf.rb'

puts "🔧 Popolamento parametri per generazione PDF..."

# Definisce i parametri necessari per i PDF con valori di default
parametri_pdf = {
  # Parametri per anteprima risultati
  'anteprima_risultati_intestazione' => {
    nome: 'Intestazione Anteprima Risultati',
    valore: %Q{
      <div style="text-align: center;">
        <img alt="" border="0" src="/images/rdp_intestazione.jpg" width="35%" /><br/>
        <h2>ANTEPRIMA RISULTATI ANALISI</h2>
      </div>
    }.strip
  },
  
  'anteprima_risultati_pie_pagina' => {
    nome: 'Piè di pagina Anteprima Risultati', 
    valore: %Q{
      <hr style="margin-top: 20px;">
      <p style="font-size: 10px; text-align: center;">
        Centro di Analisi Barbera - Laboratorio di Analisi Chimiche<br/>
        Via Esempio, 123 - 91100 Trapani (TP)<br/>
        Tel: 0923-123456 - Email: info@centrobarbera.it
      </p>
    }.strip
  },

  # Parametri per RDP (Rapporto di Prova)
  'rdp_stampa_intestazione' => {
    nome: 'Intestazione RDP Standard',
    valore: %Q{
      <img alt="" border="0" src="/images/rdp_intestazione.jpg" width="35%" />
    }.strip
  },

  'rdp_stampa_intestazione_con_sinal' => {
    nome: 'Intestazione RDP con SINAL',
    valore: %Q{
      <img alt="" border="0" src="/images/rdp_intestazione.jpg" width="35%" />
      <p style="text-align: center; font-weight: bold;">
        Laboratorio accreditato SINAL n° 0123
      </p>
    }.strip
  },

  'lab_comune' => {
    nome: 'Località del Laboratorio',
    valore: 'Trapani'
  },

  'rdp_stampa_firma' => {
    nome: 'Sezione Firma RDP',
    valore: %Q{
      <div style="padding-left: 10cm; text-align: center;">
        > Responsabile del Laboratorio Dott. F.sco Massimiliano Barbera </<br/>
        ___________________________
      </div>
    }.strip
  },

  'rdp_stampa_sinal' => {
    nome: 'Note SINAL per RDP',
    valore: %Q{
      <p style="font-size: 9px;">
        <sup>(1)</sup> Pareri ed interpretazioni - non oggetto dell'accreditamento SINAL.
      </p>
    }.strip
  },

  'rdp_stampa_pie_pagina_1' => {
    nome: 'Prima riga piè di pagina RDP',
    valore: %Q{
      <hr style="margin-top: 10px;">
      <p style="font-size: 9px;">
        Il rapporto di prova non può essere riprodotto parzialmente e riguarda solamente il campione sottoposto a prova
      </p>
    }.strip
  },

  'rdp_stampa_frase_per_supplemento' => {
    nome: 'Frase per supplementi RDP',
    valore: 'Il presente supplemento annulla e sostituisce il rapporto di prova a cui fa riferimento'
  },

  'rdp_stampa_pie_pagina_3' => {
    nome: 'Ultima riga piè di pagina RDP',
    valore: %Q{
      Autorizzazione MIPAF al rilascio dei certificati validi ai fini della commercializzazione ed esportazione dei vini (prot. 60662 del 13/03/1996)
      Autorizzazione MIPAF al rilascio dei certificati validi ai fini della commercializzazione ed esportazione degli oli (prot. ...)
    }.strip
  },

  'rdp_stampa_sinal_pie_pagina' => {
    nome: 'Piè di pagina SINAL per RDP',
    valore: 'Frase che compare in piè di pagina quando la tipologia è marcata SINAL'
  },

  # Altri parametri utili
  'dati_stampa_intestazione' => {
    nome: 'Intestazione stampa dati',
    valore: %Q{
      <img alt="" border="0" src="/images/rdp_intestazione.jpg" width="35%" />
    }.strip
  },

  'dati_stampa_titolo' => {
    nome: 'Titolo stampa anteprima analisi',
    valore: 'Anteprima Rapporto di Prova'
  },

  'email_cc_per_notifiche' => {
    nome: 'Email CC per notifiche', 
    valore: 'centrobarrerabackup@gmail.com'
  },

  'email_mittente_per_notifiche' => {
    nome: 'Email mittente per notifiche',
    valore: 'ceblab@tiscali.it'
  },

  'email_oggetto_invio_rdp_e_anteprime' => {
    nome: 'Oggetto email invio RDP',
    valore: 'Invio Dati Analisi'
  },

  'email_oggetto_rapporto_pronto' => {
    nome: 'Oggetto email rapporto pronto',
    valore: 'Analisi Pronto'
  },

  'email_testo_invio_rdp_e_anteprime' => {
    nome: 'Testo email invio RDP',
    valore: %Q{
      Allego dati relativi alle prove richieste. Nel rimanere a vs completa disposizione, porgo i miei più cordiali saluti.
      Dott. Francesco Massimiliano Barbera
    }.strip
  },

  'email_testo_rapporto_pronto' => {
    nome: 'Testo email rapporto pronto',
    valore: %Q{
      Allego tabella riepilogativa relativa alle prove richieste. Nel rimanere a vs completa disposizione, porgo i miei più cordiali saluti.
      Dott. Francesco Massimiliano Barbera
    }.strip
  }
}

# Crea i parametri nel database
parametri_creati = 0
parametri_aggiornati = 0

parametri_pdf.each do |codice, dati|
  parametro = Parametro.find_by_codice(codice)
  
  if parametro.nil?
    # Crea nuovo parametro
    parametro = Parametro.new
    parametro.codice = codice
    parametro.nome = dati[:nome]
    parametro.valore = dati[:valore]
    
    if parametro.save
      puts "✅ Creato parametro: #{codice}"
      parametri_creati += 1
    else
      puts "❌ Errore creando parametro #{codice}: #{parametro.errors.full_messages.join(', ')}"
    end
  else
    # Aggiorna parametro esistente se è vuoto
    if parametro.valore.blank?
      parametro.nome = dati[:nome]
      parametro.valore = dati[:valore]
      
      if parametro.save
        puts "🔄 Aggiornato parametro vuoto: #{codice}"
        parametri_aggiornati += 1
      else
        puts "❌ Errore aggiornando parametro #{codice}: #{parametro.errors.full_messages.join(', ')}"
      end
    else
      puts "ℹ️  Parametro già presente: #{codice}"
    end
  end
end

puts "\n🎉 Completato!"
puts "📊 Parametri creati: #{parametri_creati}"
puts "🔄 Parametri aggiornati: #{parametri_aggiornati}"
puts "\n💡 Ora dovresti essere in grado di generare i PDF correttamente!"
puts "🔍 Prova a cliccare su 'Anteprima' o 'PDF' per un rapporto di prova."

# Verifica che l'immagine dell'intestazione esista
intestazione_path = File.join(Rails.root, 'public', 'images', 'rdp_intestazione.jpg')
unless File.exist?(intestazione_path)
  puts "\n⚠️  ATTENZIONE: L'immagine dell'intestazione non è stata trovata."
  puts "   Percorso atteso: #{intestazione_path}"
  puts "   Assicurati che l'immagine esista o modifica i parametri per utilizzare un'immagine diversa."
end
