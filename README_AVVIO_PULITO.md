# 🚀 Guida Avvio Pulito - Barbera Software

## Panoramica Sistema
- **Stack**: Ruby on Rails 2.3.8, MySQL 5.5, Docker
- **Funzionalità**: Sistema di gestione rapporti laboratorio con generazione PDF
- **Database**: Include 22 parametri configurazione + 1 rapporto di esempio completo

## 📋 Prerequisiti
- Docker Desktop installato
- Git per clonare il repository
- 4GB RAM liberi per i container

## 🏗️ Procedura Avvio da Zero

### 1. Pulizia Ambiente (opzionale)
```powershell
# Rimuovi container e volumi esistenti
docker-compose down -v
docker system prune -f
docker volume prune -f
```

### 2. Preparazione File Necessari
Assicurati di avere questi file nella directory:
- `docker-compose.yml` 
- `Dockerfile`
- `barbera_complete_export.sql` (export database con dati)
- `prince_wrapper.sh` (wrapper corretto per PDF)

### 3. Avvio Container
```powershell
# Avvia MySQL e attendi che sia pronto
docker-compose up -d db

# Attendi 30 secondi per MySQL
Start-Sleep 30

# Avvia applicazione Rails
docker-compose up -d web
```

### 4. Configurazione Database
```powershell
# Importa schema e dati
docker exec barberasoftware-db-1 mysql -u barbera -pbarbera2025 barbera_development < barbera_complete_export.sql

# Verifica importazione
docker exec barberasoftware-db-1 mysql -u barbera -pbarbera2025 -e "USE barbera_development; SELECT COUNT(*) as parametri FROM parametri; SELECT COUNT(*) as rapporti FROM rapporti;"
```

### 5. Configurazione Wrapper PDF
```powershell
# Copia wrapper PDF corretto
docker cp prince_wrapper.sh barberasoftware-web-1:/usr/local/bin/prince
docker exec barberasoftware-web-1 chmod +x /usr/local/bin/prince

# Testa funzionamento PDF
docker exec barberasoftware-web-1 bash -c "echo '<html><body><h1>Test</h1></body></html>' | prince --silent - -o /tmp/test.pdf && ls -la /tmp/test.pdf"
```

### 6. Verifica Applicazione
```powershell
# Controlla che l'app sia attiva
docker exec barberasoftware-web-1 curl -I http://localhost:3000

# Visualizza log se necessario
docker logs barberasoftware-web-1 -f
```

## 🌐 Accesso Sistema

### URL Principale
**http://localhost:3000**

### Credenziali Admin
- **Email**: `info@centrobarbera.it`
- **Password**: `barbera2025`

### Pagine Principali
- **Login**: http://localhost:3000/login
- **Rapporti**: http://localhost:3000/rapporti
- **Parametri**: http://localhost:3000/parametri
- **Test PDF**: http://localhost:3000/rapporti/rdp/1?format=pdf

## 📊 Dati Inclusi

### Parametri di Configurazione (22 totali)
- Configurazioni email e SMS
- Intestazioni e footer rapporti
- Parametri laboratorio
- Configurazioni stampa PDF

### Rapporto di Esempio
- **ID**: 1
- **Numero**: 666/2014
- **Campione**: Vino Rosso Test DOC
- **Variabili**: Acidità totale, Grado alcolico
- **Cliente**: Centro Enochimico Barbera
- **Status**: Completo e pronto per PDF

## 🔧 Struttura File

```
Barbera  software/
├── docker-compose.yml           # Configurazione container
├── Dockerfile                   # Immagine Rails
├── barbera_complete_export.sql  # Database con dati
├── prince_wrapper.sh            # Wrapper PDF
├── app/                         # Codice Rails
├── public/stylesheets/          # CSS migliorati
└── vendor/plugins/              # Plugin Rails
```

## 🐛 Risoluzione Problemi

### Container non si avvia
```powershell
docker-compose logs db
docker-compose logs web
```

### Database vuoto
```powershell
# Re-importa dati
docker exec barberasoftware-db-1 mysql -u barbera -pbarbera2025 barbera_development < barbera_complete_export.sql
```

### PDF vuoti
```powershell
# Verifica wrapper PDF
docker exec barberasoftware-web-1 cat /usr/local/bin/prince
# Deve contenere "xvfb-run -a wkhtmltopdf"
```

### Errori permessi
```powershell
# Ripristina permessi
docker exec barberasoftware-web-1 chmod +x /usr/local/bin/prince
```

## 🔄 Comandi Utili

### Backup Database
```powershell
docker exec barberasoftware-db-1 mysqldump -u barbera -pbarbera2025 barbera_development > backup_$(Get-Date -Format "yyyyMMdd_HHmm").sql
```

### Restart Completo
```powershell
docker-compose restart
```

### Accesso Shell Container
```powershell
# Rails console
docker exec -it barberasoftware-web-1 bash

# MySQL console  
docker exec -it barberasoftware-db-1 mysql -u barbera -pbarbera2025 barbera_development
```

### Log Real-time
```powershell
docker-compose logs -f web
```

## ✅ Checklist Post-Installazione

- [ ] Container MySQL e Rails attivi
- [ ] Database importato (22 parametri + 1 rapporto)
- [ ] Login funzionante con credenziali admin
- [ ] PDF generation funzionante
- [ ] Wrapper prince configurato con xvfb
- [ ] CSS aggiornati per impaginazione corretta
- [ ] Accesso a tutte le sezioni principali

## 📝 Note Tecniche

### Porte Utilizzate
- **3000**: Applicazione Rails
- **3306**: Database MySQL (interno)

### Volumi Docker
- `barberasoftware_db_data`: Dati MySQL persistenti
- `barberasoftware_bundle_cache`: Cache gem Ruby
- `barberasoftware_pdf_data`: File PDF generati

### Modifiche Applicate
- **Wrapper PDF**: Usa xvfb-run per wkhtmltopdf
- **CSS**: Impaginazione migliorata per stampa
- **Layout**: Struttura professionale per rapporti
- **Database**: Schema completo con dati di esempio

---
**🎯 Risultato**: Sistema laboratorio completo e funzionante con generazione PDF professionale 