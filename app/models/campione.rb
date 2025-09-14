class Campione < ActiveRecord::Base


  belongs_to :cliente

  has_many :rapporti, :dependent => :destroy # cancello il campione, e cancello anche i suoi rapporti
  has_many :tipologie, :through => :rapporti

  before_destroy :cancella_pure_dato_che_non_e_utilizzato


  #validates_presence_of :cliente, :data, :numero, :anno
  validates_presence_of :cliente, :data, :anno
  #validates_numericality_of :numero, :only_integer => true, :allow_nil => false

  validates_uniqueness_of :numero,
                          # ocio alla prossima per i campioni
                          #:allow_nil => false,
                          :allow_nil => true,
                          :scope => 'anno',
                          :message => "è già in uso per l'anno selezionato"

  validates_inclusion_of  :numero,
                          :in => 1..10000,
                          :allow_nil => true,
                          :message => 'deve essere compreso tra 1 e 9999 (o assente)'

  def to_label
    if cliente.nil? 
      nome_cliente = ''
    else
      nome_cliente = cliente.to_label
    end
    if self.numero.nil?
      return "R.c. ??/#{anno} - #{nome_cliente}"
    else
      return "R.c. #{numero}/#{anno} - #{nome_cliente}"
    end

  end


  
#  def etichetta=(testo)
#    # metto sempre l'iniziale maiuscola e levo spazi prima e dopo
#    unless testo.nil?
#      # non usare "strip!", usa invece "strip"
#      testo = testo.to_s.strip
#      testo = (testo.slice(0,1)).upcase+(testo.slice(1..-1)).to_s
#    end
#    write_attribute(:etichetta, testo)
#  end

#  MANCA DA AGGIUNGERE COSTO TIPOLOGIE
#  def prezzo
#    prezzo = 0.0
#    unless self.prove.empty?
#      self.prove.each do |prova|
#        prezzo += prova.prezzo
#      end
#    end
#    return prezzo
#  end

  def cancella_pure_dato_che_non_e_utilizzato
    if !self.utilizzato?
      return true
    else
       raise "Non posso cancellare una Campione se utilizzato"
       logger.info( "Tentativo di cancellazione di campione utilizzato" )
      return false
    end
  end

  def utilizzato?
    if self.rapporti.empty?
      return false
    else
      return true
    end
  end

  def fatturato?
    numero_fatture = 0
    self.rapporti.each do |rapporto|
      numero_fatture +=1 if rapporto.fattura
    end
    return numero_fatture > 0
  end

  def validate
    errors.add "Errore:", "Campione non modificabile in quanto legato ad un rapporto già fatturato" if self.fatturato?
  end
end
