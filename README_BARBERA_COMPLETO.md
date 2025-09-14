# Barbera Software - Versione Completa

## Introduzione

Questa è la versione completa e unificata del software Barbera, che include tutte le correzioni necessarie per risolvere i problemi precedentemente riscontrati, in particolare l'errore 500 nella pagina Prove quando si tenta di modificare o eliminare i record.

## Correzioni Implementate

1. **Tabella mancante `auto_prova_rapporto_items`**: È stata aggiunta al database, risolvendo l'errore 500 nella pagina Prove.
2. **Miglioramenti alla tabella `variabili`**: Sono state aggiunte tutte le colonne necessarie per il corretto funzionamento.
3. **Schema completo del database**: Tutte le tabelle e le correzioni sono state unificate in un unico file SQL.

## Requisiti

- Docker Desktop installato e in esecuzione
- Almeno 4GB di RAM disponibile
- Porta 3000 disponibile (per l'interfaccia web)
- Porta 3306 disponibile (per il database MySQL)

## Come Utilizzare

### Avvio dell'Applicazione

Per avviare l'applicazione, eseguire semplicemente:

```
avvia-barbera-completo.bat
```

Questo script:
- Verifica l'ambiente Docker
- Costruisce l'immagine Docker se necessario
- Avvia i container
- Configura automaticamente il database con tutte le correzioni

### Arresto dell'Applicazione

Per arrestare l'applicazione, eseguire:

```
arresta-barbera-completo.bat
```

### Accesso all'Applicazione

Dopo l'avvio, l'applicazione sarà disponibile all'indirizzo:
- http://localhost:3000

Credenziali di accesso:
- Email: info@centrobarbera.it
- Password: barbera2025

## Risoluzione dei Problemi

Se incontri problemi:

1. **L'applicazione non risponde**: Prova a riavviare i container con `docker-compose restart`
2. **Errori di database**: Verifica che il container del database sia in esecuzione con `docker-compose ps`
3. **Errori nell'interfaccia web**: Controlla i log con `docker-compose logs -f web`

## File Importanti

- `docker-compose.yml`: Configurazione dei container Docker
- `barbera_development_complete.sql`: Schema completo del database con tutte le correzioni
- `avvia-barbera-completo.bat`: Script unificato per l'avvio dell'applicazione
- `arresta-barbera-completo.bat`: Script per arrestare l'applicazione

## Note Aggiuntive

I file precedenti (`fix-database.bat`, `fix_auto_prova_rapporto_items.sql`, ecc.) non sono più necessari poiché tutte le correzioni sono state integrate nella nuova versione unificata. 