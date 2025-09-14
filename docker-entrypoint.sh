#!/bin/bash
set -e

# Crea la directory PDF se non esiste
mkdir -p /app/pdf
chmod 777 /app/pdf

# Configura i DNS server se possibile
if [ -w /etc/resolv.conf ]; then
  echo "nameserver 8.8.8.8" > /etc/resolv.conf
  echo "nameserver 8.8.4.4" >> /etc/resolv.conf
fi

# Attendi che MySQL sia pronto
echo "Waiting for MySQL to be ready..."
counter=1
while ! nc -z 172.19.0.2 3306; do
  sleep 3
  counter=$((counter+1))
  if [ $counter -gt 10 ]; then
    echo "Could not connect to MySQL after 30 seconds. Continuing anyway..."
    break
  fi
done

# Crea il database se non esiste già
echo "Checking database..."
mysql -h 172.19.0.2 -u root -ppassword -e "CREATE DATABASE IF NOT EXISTS barbera_${RAILS_ENV};"

# Carica lo schema del database se necessario
if [ -f /app/barbera_development_schema_only.sql ]; then
  if [ $(mysql -h 172.19.0.2 -u root -ppassword -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'barbera_${RAILS_ENV}';" | grep -v "COUNT" | tr -d '[:space:]') -eq "0" ]; then
    echo "Loading database schema..."
    mysql -h 172.19.0.2 -u root -ppassword barbera_${RAILS_ENV} < /app/barbera_development_schema_only.sql
    
    # Esegui il seed per creare i dati base
    echo "Loading seed data..."
    cd /app && bundle exec rake db:seed RAILS_ENV=${RAILS_ENV}
  else
    echo "Database already populated, skipping import"
  fi
fi

# Esegui l'applicazione
exec "$@" 