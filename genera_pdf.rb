#!/usr/bin/env ruby

# Script per generare i PDF dei rapporti
# Per eseguire questo script:
#
# 1. Entrare nella console dell'ambiente desiderato:
#    script/console
#
# 2. Caricare lo script:
#    load File.join(RAILS_ROOT, 'genera_pdf.rb')
#
# Il script genera PDF per tutti i rapporti completi che hanno numero e anno assegnati.

require 'net/http'
require 'princely' if defined?(Princely)

# Verifica che la directory per i PDF esista
pdf_dir = File.join(RAILS_ROOT, 'pdf')
Dir.mkdir(pdf_dir) unless File.exist?(pdf_dir)

# Recupera tutti i rapporti
puts "Avvio della generazione dei PDF per i rapporti..."
rapporti = Rapporto.all
count = 0

rapporti.each do |rapporto|
  if rapporto.completo? && !rapporto.numero.blank? && !rapporto.anno.blank?
    # Rimuovere questo filtro se si vogliono generare i PDF per tutti i rapporti
    # Questo filtro limita la generazione ai rapporti con numeri 1051-1195
    if rapporto.numero >= 1051 && rapporto.numero <= 1195
      begin
        puts "Generazione PDF per rapporto ##{rapporto.numero}/#{rapporto.anno}..."
        
        # Usa localhost:3000 per l'ambiente di sviluppo
        host = RAILS_ENV == 'development' ? 'localhost:3000' : 'localhost'
        
        # Utilizza PrinceXML tramite Princely se disponibile, altrimenti usa HTTP
        if defined?(Princely)
          begin
            # Ottieni l'HTML del rapporto
            controller = ActionController::Integration::Session.new
            controller.get("/rapporti/rdp/#{rapporto.id}")
            html = controller.response.body
            
            # Genera il PDF con PrinceXML
            prince = Princely.new
            pdf_data = prince.pdf_from_string(html)
            
            # Salva il PDF
            nome_file = rapporto.nome_file_pdf_del_rapporto_con_path_assoluto
            File.open(nome_file, 'wb') do |f|
              f.write(pdf_data)
            end
            
            puts "PDF generato con successo tramite PrinceXML per rapporto ##{rapporto.numero}/#{rapporto.anno}"
          rescue => e
            # Se fallisce con Princely, prova con HTTP
            puts "Errore con PrinceXML: #{e.message}, provo con HTTP..."
            response = Net::HTTP.get(URI.parse("http://#{host}/rapporti/crea_pdf/#{rapporto.id}"))
          end
        else
          # Utilizza il metodo HTTP standard
          response = Net::HTTP.get(URI.parse("http://#{host}/rapporti/crea_pdf/#{rapporto.id}"))
        end
        
        count += 1
        puts "PDF generato con successo per rapporto ##{rapporto.numero}/#{rapporto.anno}"
      rescue => e
        puts "Errore durante la generazione del PDF per rapporto ##{rapporto.numero}/#{rapporto.anno}: #{e.message}"
      end
    end
  end
end

puts "Generazione PDF completata. #{count} PDF generati."
