# Istruzioni per Testare le Correzioni PDF

## Modifiche Implementate

### 1. Wrapper Prince Corretto (`prince_wrapper.sh`)
- ✅ Gestisce correttamente i parametri di wkhtmltopdf
- ✅ Converte i comandi PrinceXML in comandi wkhtmltopdf
- ✅ Aggiunge parametri di formattazione corretti (A4, margini, encoding)

### 2. Configurazione Princely Aggiornata (`vendor/plugins/princely/lib/princely.rb`)
- ✅ Cerca automaticamente il wrapper prince_wrapper.sh se prince non è disponibile
- ✅ Prepara l'HTML per wkhtmltopdf convertendo i percorsi
- ✅ Gestisce meglio gli errori di generazione

### 3. Gestione Percorsi CSS (`vendor/plugins/princely/lib/princely/pdf_helper.rb`)
- ✅ Converte percorsi relativi in assoluti per immagini e CSS
- ✅ Rimuove query parameters dai CSS
- ✅ Aggiunge meta tag per wkhtmltopdf

### 4. Gestione Errori Migliorata (`app/controllers/rapporti_controller.rb`)
- ✅ Validazione completa dei dati prima della generazione
- ✅ Creazione automatica della directory PDF
- ✅ Verifica del PDF generato
- ✅ Logging dettagliato degli errori
- ✅ Messaggi di feedback per l'utente

### 5. Directory PDF
- ✅ Directory `pdf/` creata
- ✅ Permessi corretti configurati

## Come Testare le Correzioni

### Test 1: Verifica Configurazione Base
```bash
# Verifica che il wrapper prince funzioni
./prince_wrapper.sh --version
# Dovrebbe restituire: Prince 14.2 (wkhtmltopdf wrapper)

# Verifica che la directory PDF esista
ls -la pdf/
# Dovrebbe mostrare la directory vuota
```

### Test 2: Test Generazione PDF (Console Rails)
```ruby
# Avvia la console Rails
script/console

# Carica lo script di test
load File.join(RAILS_ROOT, 'test_pdf_generation.rb')

# Esegui il test
test_pdf_generation
```

### Test 3: Test via Web Interface
1. Accedi all'interfaccia web dell'applicazione
2. Vai alla sezione rapporti
3. Seleziona un rapporto completo (con numero e anno)
4. Clicca su "Crea PDF" o "Rapporto"
5. Verifica che il PDF venga generato senza errori

### Test 4: Verifica Log
```bash
# Controlla i log per errori
tail -f log/development.log
tail -f log/prince.log

# Cerca errori specifici
grep -i "prince\|pdf\|error" log/development.log
```

## Risoluzione Problemi Comuni

### Problema: "Cannot find prince command-line app"
**Soluzione**: Il wrapper prince_wrapper.sh deve essere eseguibile
```bash
chmod +x prince_wrapper.sh
```

### Problema: "PDF generato non valido"
**Soluzione**: Verifica che wkhtmltopdf sia installato e funzionante
```bash
which wkhtmltopdf
wkhtmltopdf --version
```

### Problema: "File PDF non creato correttamente"
**Soluzione**: Verifica i permessi della directory PDF
```bash
chmod 777 pdf/
```

### Problema: CSS non caricati
**Soluzione**: Verifica che i file CSS esistano
```bash
ls -la public/stylesheets/rdp.css
ls -la public/stylesheets/prince.css
```

## File di Debug

- `log/last_pdf_html.html` - HTML generato per il PDF (per debug)
- `log/prince.log` - Log specifico di Prince/wkhtmltopdf
- `log/development.log` - Log generale dell'applicazione

## Note Importanti

1. **Ambiente Docker**: Le correzioni sono ottimizzate per l'ambiente Docker con wkhtmltopdf
2. **Compatibilità**: Il sistema funziona sia con PrinceXML che con wkhtmltopdf
3. **Fallback**: In caso di errore, viene generato un PDF di fallback minimo ma valido
4. **Logging**: Tutti gli errori vengono loggati per facilitare il debug

## Verifica Finale

Dopo aver applicato tutte le correzioni, dovresti essere in grado di:
- ✅ Generare PDF dei rapporti senza errori
- ✅ Visualizzare i PDF generati
- ✅ Ricevere feedback appropriato in caso di errori
- ✅ Vedere log dettagliati per il debug

Se incontri ancora problemi, controlla i log e verifica che tutti i file di configurazione siano stati aggiornati correttamente.
