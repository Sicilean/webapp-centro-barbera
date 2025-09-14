#!/bin/bash

# Wrapper per convertire comandi PrinceXML in comandi wkhtmltopdf
# Gestisce i parametri specifici di PrinceXML e li converte per wkhtmltopdf

if [ "$1" = "--version" ]; then
  echo "Prince 14.2 (wkhtmltopdf wrapper)"
  exit 0
fi

# Parametri di base per wkhtmltopdf (formato A4, margini corretti)
BASE_PARAMS="--page-size A4 --margin-top 2cm --margin-right 1.5cm --margin-bottom 3cm --margin-left 1.5cm --encoding UTF-8 --disable-smart-shrinking --print-media-type"

# Se il comando contiene --silent - -o -, usa stdin/stdout
if [[ "$*" == *"--silent - -o -"* ]]; then
  # Input da stdin, output su stdout
  xvfb-run -a wkhtmltopdf $BASE_PARAMS --quiet - -
elif [[ "$*" =~ --silent\ -\ -o\ \'([^\']+)\' ]]; then
  # Input da stdin, output su file specificato
  output_file="${BASH_REMATCH[1]}"
  xvfb-run -a wkhtmltopdf $BASE_PARAMS --quiet - "$output_file"
elif [[ "$*" =~ --silent\ -\ -o\ ([^\ ]+) ]]; then
  # Input da stdin, output su file specificato (senza apici)
  output_file="${BASH_REMATCH[1]}"
  xvfb-run -a wkhtmltopdf $BASE_PARAMS --quiet - "$output_file"
else
  # Gestisci altri casi passando tutti gli argomenti
  xvfb-run -a wkhtmltopdf $BASE_PARAMS --quiet "$@"
fi 