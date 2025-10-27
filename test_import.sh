#!/bin/bash

# Script di test per verificare l'importazione dei dati
# Questo script può essere eseguito per testare l'importazione senza avviare l'applicazione

echo "=== Test Importazione Dati Barbera Software ==="

# Verifica che MySQL sia disponibile
echo "Checking MySQL connection..."
if ! mysql -h 172.19.0.2 -u root -ppassword -e "SELECT 1;" >/dev/null 2>&1; then
    echo "ERROR: Could not connect to MySQL"
    echo "Make sure MySQL container is running on 172.19.0.2:3306"
    exit 1
fi

echo "MySQL connection successful!"

# Crea il database se non esiste
echo "Creating database if not exists..."
mysql -h 172.19.0.2 -u root -ppassword -e "CREATE DATABASE IF NOT EXISTS barbera_test;"

# Esegui l'importazione nel database di test
echo "Starting data import test..."

# Esegui i chunk di importazione in ordine
echo "Executing chunk 1: Setup..."
mysql -h 172.19.0.2 -u root -ppassword barbera_test < /app/import_chunk_01_setup.sql

echo "Executing chunk 2: Matrici e Parametri..."
mysql -h 172.19.0.2 -u root -ppassword barbera_test < /app/import_chunk_02_matrici_parametri.sql

echo "Executing chunk 3: Clienti parte 1..."
mysql -h 172.19.0.2 -u root -ppassword barbera_test < /app/import_chunk_03_clienti_parte1.sql

echo "Executing chunk 4: Clienti parte 2..."
mysql -h 172.19.0.2 -u root -ppassword barbera_test < /app/import_chunk_04_clienti_parte2.sql

echo "Executing chunk 5: Clienti parte 3..."
mysql -h 172.19.0.2 -u root -ppassword barbera_test < /app/import_chunk_05_clienti_parte3.sql

echo "Executing chunk 6: Prove complete..."
mysql -h 172.19.0.2 -u root -ppassword barbera_test < /app/import_chunk_06_prove_complete.sql

echo "Executing chunk 7: Tipologie complete..."
mysql -h 172.19.0.2 -u root -ppassword barbera_test < /app/import_chunk_07_tipologie_complete.sql

echo "Executing chunk 8: Variabili sample..."
mysql -h 172.19.0.2 -u root -ppassword barbera_test < /app/import_chunk_08_variabili_sample.sql

echo "✅ Data import test completed!"

# Verifica i risultati
echo ""
echo "=== Verifica Importazione ==="

echo "Clienti importati:"
mysql -h 172.19.0.2 -u root -ppassword -e "SELECT COUNT(*) as 'Clienti' FROM barbera_test.clienti;"

echo "Prove importate:"
mysql -h 172.19.0.2 -u root -ppassword -e "SELECT COUNT(*) as 'Prove' FROM barbera_test.prove;"

echo "Tipologie importate:"
mysql -h 172.19.0.2 -u root -ppassword -e "SELECT COUNT(*) as 'Tipologie' FROM barbera_test.tipologie;"

echo "Variabili importate:"
mysql -h 172.19.0.2 -u root -ppassword -e "SELECT COUNT(*) as 'Variabili' FROM barbera_test.variabili;"

echo "Matrici importate:"
mysql -h 172.19.0.2 -u root -ppassword -e "SELECT COUNT(*) as 'Matrici' FROM barbera_test.matrici;"

echo "Parametri importati:"
mysql -h 172.19.0.2 -u root -ppassword -e "SELECT COUNT(*) as 'Parametri' FROM barbera_test.parametri;"

echo ""
echo "=== Test Completato ==="
echo "Se tutti i contatori mostrano valori > 0, l'importazione è avvenuta con successo!"
