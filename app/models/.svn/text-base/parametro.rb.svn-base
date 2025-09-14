class Parametro < ActiveRecord::Base

  validates_presence_of :codice
  validates_uniqueness_of :codice, :case_sensitive => false

  # nb.  Valore è già pari a '' da database
  def to_label
    "#{codice}"
  end

  def nome=(testo)
    # metto sempre l'iniziale maiuscola e levo spazi prima e dopo
    unless testo.nil?
      # non usare "strip!", usa invece "strip"
      testo = testo.to_s.strip
      testo = (testo.slice(0,1)).upcase+(testo.slice(1..-1)).to_s
    end
    write_attribute(:nome, testo)
  end
  
  def codice=(testo)
    testo = testo.downcase unless testo.nil?
    write_attribute(:codice, testo)
  end  

end
