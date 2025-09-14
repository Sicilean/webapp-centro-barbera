# 
# per eseguire la seguente si entra nell'ambiente che ti interessa,
# e di da
#
#script/console
#load '/home/dante/rails/centroenowine.dyndns.org/genera_pdf.rb'
#
#sul server
#load '~/rails_work/barbera/genera_pdf.rb'
# ma attenzione che funziona solo se si elimina la password
# e prima sarebbe bene fare il forword dal loro router dalla porta 8090 alla porta 80 così siamo
# sicuri che nessuno entra


rapporti = Rapporto.all
rapporti.each do |rapporto|
  if rapporto.completo? && !rapporto.numero.blank? && !rapporto.anno.blank?
      if rapporto.numero >= 1051 && rapporto.numero <=1195
        # html = Net::HTTP.get(URI.parse("http://localhost:3000/rapporti/crea_pdf/#{rapporto.id}"))
        html = Net::HTTP.get(URI.parse("http://localhost/rapporti/crea_pdf/#{rapporto.id}"))
      end
  end
end
