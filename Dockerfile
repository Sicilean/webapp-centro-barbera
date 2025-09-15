FROM debian:jessie

# Configura i repository Debian Jessie
RUN echo "deb http://archive.debian.org/debian/ jessie main" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security jessie/updates main" >> /etc/apt/sources.list && \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/10no-check-valid-until

# Installa le dipendenze di sistema
RUN apt-get update && apt-get install -y --force-yes \
    build-essential \
    libmysqlclient-dev \
    mysql-client \
    libreadline-dev \
    libssl-dev \
    zlib1g-dev \
    curl \
    wget \
    git \
    fontconfig \
    libxrender1 \
    xfonts-base \
    xfonts-75dpi \
    netcat \
    wkhtmltopdf \
    && rm -rf /var/lib/apt/lists/*

# Utilizza wkhtmltopdf come alternativa a PrinceXML
RUN echo '#!/bin/bash' > /usr/local/bin/prince && \
    echo 'if [ "$1" = "--version" ]; then' >> /usr/local/bin/prince && \
    echo '  echo "Prince 14.2 (wkhtmltopdf wrapper)"' >> /usr/local/bin/prince && \
    echo '  exit 0' >> /usr/local/bin/prince && \
    echo 'fi' >> /usr/local/bin/prince && \
    echo 'if [[ "$*" == *"--silent - -o -"* ]]; then' >> /usr/local/bin/prince && \
    echo '  wkhtmltopdf - -' >> /usr/local/bin/prince && \
    echo 'elif [[ "$*" =~ "--silent - -o '"'"'([^'"'"']+)'"'"'" ]]; then' >> /usr/local/bin/prince && \
    echo '  output_file=${BASH_REMATCH[1]}' >> /usr/local/bin/prince && \
    echo '  wkhtmltopdf - "$output_file"' >> /usr/local/bin/prince && \
    echo 'else' >> /usr/local/bin/prince && \
    echo '  wkhtmltopdf "$@"' >> /usr/local/bin/prince && \
    echo 'fi' >> /usr/local/bin/prince && \
    chmod +x /usr/local/bin/prince

# Scarica e installa Ruby 1.8.7
RUN cd /tmp && \
    (echo "nameserver 8.8.8.8" > /etc/resolv.conf.new && cat /etc/resolv.conf.new > /etc/resolv.conf || true) && \
    wget --no-check-certificate https://cache.ruby-lang.org/pub/ruby/1.8/ruby-1.8.7-p374.tar.gz && \
    tar xzf ruby-1.8.7-p374.tar.gz && \
    cd ruby-1.8.7-p374 && \
    ./configure --disable-install-doc && \
    make && \
    make install && \
    cd .. && \
    rm -rf ruby-1.8.7-p374*

# Scarica e installa RubyGems 1.3.7
RUN cd /tmp && \
    (echo "nameserver 8.8.8.8" > /etc/resolv.conf.new && cat /etc/resolv.conf.new > /etc/resolv.conf || true) && \
    wget --no-check-certificate https://github.com/rubygems/rubygems/archive/v1.3.7.tar.gz -O rubygems-1.3.7.tgz && \
    tar xzf rubygems-1.3.7.tgz && \
    cd rubygems-1.3.7 && \
    ruby setup.rb && \
    cd .. && \
    rm -rf rubygems-1.3.7*

# Configura RubyGems
RUN mkdir -p ~/.gem && \
    echo ':ssl_verify_mode: 0' > ~/.gemrc && \
    echo ':sources: ["http://rubygems.org"]' >> ~/.gemrc && \
    echo ':update_sources: false' >> ~/.gemrc && \
    echo ':backtrace: false' >> ~/.gemrc && \
    echo ':benchmark: false' >> ~/.gemrc

# Installa le gemme necessarie
WORKDIR /gems
RUN mkdir -p /gems && \
    cd /gems && \
    (echo "nameserver 8.8.8.8" > /etc/resolv.conf.new && cat /etc/resolv.conf.new > /etc/resolv.conf || true) && \
    wget --no-check-certificate https://rubygems.org/downloads/rake-0.8.7.gem && \
    wget --no-check-certificate https://rubygems.org/downloads/rack-1.1.0.gem && \
    wget --no-check-certificate https://rubygems.org/downloads/activesupport-2.3.8.gem && \
    wget --no-check-certificate https://rubygems.org/downloads/activerecord-2.3.8.gem && \
    wget --no-check-certificate https://rubygems.org/downloads/actionpack-2.3.8.gem && \
    wget --no-check-certificate https://rubygems.org/downloads/actionmailer-2.3.8.gem && \
    wget --no-check-certificate https://rubygems.org/downloads/activeresource-2.3.8.gem && \
    wget --no-check-certificate https://rubygems.org/downloads/rails-2.3.8.gem && \
    wget --no-check-certificate https://rubygems.org/downloads/mysql-2.8.1.gem && \
    wget --no-check-certificate https://rubygems.org/downloads/authlogic-2.1.6.gem

RUN cd /gems && \
    gem install --local rake-0.8.7.gem --no-ri --no-rdoc && \
    gem install --local rack-1.1.0.gem --no-ri --no-rdoc && \
    gem install --local activesupport-2.3.8.gem --no-ri --no-rdoc && \
    gem install --local activerecord-2.3.8.gem --no-ri --no-rdoc && \
    gem install --local actionpack-2.3.8.gem --no-ri --no-rdoc && \
    gem install --local actionmailer-2.3.8.gem --no-ri --no-rdoc && \
    gem install --local activeresource-2.3.8.gem --no-ri --no-rdoc && \
    gem install --local rails-2.3.8.gem --no-ri --no-rdoc && \
    gem install --local mysql-2.8.1.gem --no-ri --no-rdoc && \
    gem install --local authlogic-2.1.6.gem --no-ri --no-rdoc

# Imposta la directory di lavoro per l'applicazione
WORKDIR /app

# Copia tutto il progetto Rails
COPY . /app/

# Crea l'entrypoint corretto
RUN echo '#!/bin/bash' > /usr/local/bin/docker-entrypoint.sh && \
    echo 'set -e' >> /usr/local/bin/docker-entrypoint.sh && \
    echo '' >> /usr/local/bin/docker-entrypoint.sh && \
    echo '# Crea la directory PDF se non esiste' >> /usr/local/bin/docker-entrypoint.sh && \
    echo 'mkdir -p /app/pdf' >> /usr/local/bin/docker-entrypoint.sh && \
    echo 'chmod 777 /app/pdf' >> /usr/local/bin/docker-entrypoint.sh && \
    echo '' >> /usr/local/bin/docker-entrypoint.sh && \
    echo '# Attendi che MySQL sia pronto' >> /usr/local/bin/docker-entrypoint.sh && \
    echo 'echo "Waiting for MySQL to be ready..."' >> /usr/local/bin/docker-entrypoint.sh && \
    echo 'counter=1' >> /usr/local/bin/docker-entrypoint.sh && \
    echo 'while ! nc -z 172.19.0.2 3306; do' >> /usr/local/bin/docker-entrypoint.sh && \
    echo '  sleep 3' >> /usr/local/bin/docker-entrypoint.sh && \
    echo '  counter=$((counter+1))' >> /usr/local/bin/docker-entrypoint.sh && \
    echo '  if [ $counter -gt 10 ]; then' >> /usr/local/bin/docker-entrypoint.sh && \
    echo '    echo "Could not connect to MySQL after 30 seconds. Continuing anyway..."' >> /usr/local/bin/docker-entrypoint.sh && \
    echo '    break' >> /usr/local/bin/docker-entrypoint.sh && \
    echo '  fi' >> /usr/local/bin/docker-entrypoint.sh && \
    echo 'done' >> /usr/local/bin/docker-entrypoint.sh && \
    echo '' >> /usr/local/bin/docker-entrypoint.sh && \
    echo '# Crea il database se non esiste' >> /usr/local/bin/docker-entrypoint.sh && \
    echo 'echo "Creating database..."' >> /usr/local/bin/docker-entrypoint.sh && \
    echo 'mysql -h 172.19.0.2 -u root -ppassword -e "CREATE DATABASE IF NOT EXISTS barbera_${RAILS_ENV};" || true' >> /usr/local/bin/docker-entrypoint.sh && \
    echo '' >> /usr/local/bin/docker-entrypoint.sh && \
    echo '# Carica lo schema del database se necessario' >> /usr/local/bin/docker-entrypoint.sh && \
    echo 'if [ -f /app/barbera_development_complete.sql ]; then' >> /usr/local/bin/docker-entrypoint.sh && \
    echo '  table_count=$(mysql -h 172.19.0.2 -u root -ppassword -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '"'"'barbera_${RAILS_ENV}'"'"';" 2>/dev/null | grep -v "COUNT" | tr -d '"'"'[:space:]'"'"' || echo "0")' >> /usr/local/bin/docker-entrypoint.sh && \
    echo '  if [ "$table_count" -eq "0" ]; then' >> /usr/local/bin/docker-entrypoint.sh && \
    echo '    echo "Loading database schema..."' >> /usr/local/bin/docker-entrypoint.sh && \
    echo '    mysql -h 172.19.0.2 -u root -ppassword barbera_${RAILS_ENV} < /app/barbera_development_complete.sql || true' >> /usr/local/bin/docker-entrypoint.sh && \
    echo '  else' >> /usr/local/bin/docker-entrypoint.sh && \
    echo '    echo "Database already populated, skipping import"' >> /usr/local/bin/docker-entrypoint.sh && \
    echo '  fi' >> /usr/local/bin/docker-entrypoint.sh && \
    echo 'fi' >> /usr/local/bin/docker-entrypoint.sh && \
    echo '' >> /usr/local/bin/docker-entrypoint.sh && \
    echo '# Avvia Rails' >> /usr/local/bin/docker-entrypoint.sh && \
    echo 'echo "Starting Rails server..."' >> /usr/local/bin/docker-entrypoint.sh && \
    echo 'cd /app' >> /usr/local/bin/docker-entrypoint.sh && \
    echo 'exec "$@"' >> /usr/local/bin/docker-entrypoint.sh && \
    chmod +x /usr/local/bin/docker-entrypoint.sh

# Crea directory per i PDF
RUN mkdir -p /app/pdf && chmod 777 /app/pdf

# Assicurati che script/server sia eseguibile
RUN chmod +x /app/script/server

# Espone la porta 3000
EXPOSE 3000

# Imposta l'entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Comando per avviare l'applicazione Rails
CMD ["ruby", "script/server", "-b", "0.0.0.0"]