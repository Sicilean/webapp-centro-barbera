#!/bin/bash

# Script per importare i dati di Barbera Software
# Questo script viene eseguito durante l'avvio del container Docker

set -e

echo "=== Barbera Software Data Import Script ==="

# Verifica che MySQL sia disponibile
echo "Checking MySQL connection..."
counter=1
while ! mysql -h ${DB_HOST:-db} -u root -ppassword -e "SELECT 1;" >/dev/null 2>&1; do
  sleep 3
  counter=$((counter+1))
  if [ $counter -gt 10 ]; then
    echo "ERROR: Could not connect to MySQL after 30 seconds"
    exit 1
  fi
done

echo "MySQL connection successful!"

# Crea il database se non esiste
echo "Creating database if not exists..."
mysql -h ${DB_HOST:-db} -u root -ppassword -e "CREATE DATABASE IF NOT EXISTS barbera_${RAILS_ENV:-development};"

# Verifica se il database ha già dati
echo "Checking if database already contains data..."
data_count=$(mysql -h ${DB_HOST:-db} -u root -ppassword -e "SELECT COUNT(*) FROM barbera_${RAILS_ENV:-development}.clienti;" 2>/dev/null | grep -v "COUNT" | tr -d '[:space:]' || echo "0")

if [ "$data_count" -eq "0" ]; then
    echo "Database is empty, starting data import..."
    
    # Esegui i chunk di importazione in ordine
    echo "Executing chunk 1: Setup..."
    mysql -h ${DB_HOST:-db} -u root -ppassword barbera_${RAILS_ENV:-development} < /app/import_chunk_01_setup.sql
    
    echo "Executing chunk 2: Matrici e Parametri..."
    mysql -h ${DB_HOST:-db} -u root -ppassword barbera_${RAILS_ENV:-development} < /app/import_chunk_02_matrici_parametri.sql
    
    echo "Executing chunk 3: Clienti parte 1..."
    mysql -h ${DB_HOST:-db} -u root -ppassword barbera_${RAILS_ENV:-development} < /app/import_chunk_03_clienti_parte1.sql
    
    echo "Executing chunk 4: Clienti parte 2..."
    mysql -h ${DB_HOST:-db} -u root -ppassword barbera_${RAILS_ENV:-development} < /app/import_chunk_04_clienti_parte2.sql
    
    echo "Executing chunk 5: Clienti parte 3..."
    mysql -h ${DB_HOST:-db} -u root -ppassword barbera_${RAILS_ENV:-development} < /app/import_chunk_05_clienti_parte3.sql
    
    echo "Executing chunk 6: Prove complete..."
    mysql -h ${DB_HOST:-db} -u root -ppassword barbera_${RAILS_ENV:-development} < /app/import_chunk_06_prove_complete.sql
    
    echo "Executing chunk 7: Tipologie complete..."
    mysql -h ${DB_HOST:-db} -u root -ppassword barbera_${RAILS_ENV:-development} < /app/import_chunk_07_tipologie_complete.sql
    
    echo "Executing chunk 8: Variabili sample..."
    mysql -h ${DB_HOST:-db} -u root -ppassword barbera_${RAILS_ENV:-development} < /app/import_chunk_08_variabili_sample.sql
    
    echo "✅ Data import completed successfully!"
    
    # Verifica finale
    final_count=$(mysql -h ${DB_HOST:-db} -u root -ppassword -e "SELECT COUNT(*) FROM barbera_${RAILS_ENV:-development}.clienti;" 2>/dev/null | grep -v "COUNT" | tr -d '[:space:]' || echo "0")
    echo "Final client count: $final_count"
    
else
    echo "Database already contains $data_count clients, skipping import"
fi

echo "=== Data Import Script Completed ==="
