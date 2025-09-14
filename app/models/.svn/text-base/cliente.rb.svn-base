class Cliente < ActiveRecord::Base

  has_many :users, :dependent => :destroy # cancello il cliente, e cancello i suoi users

  has_many :campioni, :dependent => :destroy # cancello il cliente, e cancello i suoi campioni
  has_many :fatture,  :dependent => :destroy # cancello il cliente, e cancello le sue fatture


  before_destroy :cancella_pure_dato_che_non_e_utilizzato

  validates_presence_of :nome
  validates_uniqueness_of :nome, :case_sensitive => false
  validates_uniqueness_of :codice, :allow_nil => true, :case_sensitive => false
  # il seguente commentato su richiesta di giusy
  #validates_uniqueness_of :partita_iva, :allow_nil => true
  validates_numericality_of :codice, :only_integer => true, :allow_nil => true
  validates_numericality_of :cap, :only_integer => true, :allow_nil => true
  validates_length_of :cap, :is => 5, :allow_nil => true
  validates_length_of :partita_iva, :is => 11, :allow_nil => true
  validates_length_of :codice_fiscale, :is => 16, :allow_nil => true
 
  def to_label
    "#{nome}"
  end

  def codice_fiscale=(testo)
    testo = testo.upcase unless testo.nil? # non è mai pari a nil (visto ke arriva da un form, ma non si sa mai)
    write_attribute(:codice_fiscale, testo)
  end

  def email_per_notifiche=(testo)
    testo = testo.downcase unless testo.nil? # non è mai pari a nil (visto ke arriva da un form, ma non si sa mai)
    write_attribute(:email_per_notifiche, testo)
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

  def prezzo
    read_attribute(:prezzo) / 100
  end

  def rapporti
    rapporti_totali = Array.new
    self.campioni.each do |campione|
      campione.rapporti.each do |rapporto|
       rapporti_totali << rapporto
      end
    end
    return rapporti_totali
  end

  def rapporti_completi
    rapporti_totali = Array.new
    self.campioni.each do |campione|
      campione.rapporti.each do |rapporto|
       (rapporti_totali << rapporto) if rapporto.status == 'completo'
      end
    end
    return rapporti_totali
  end

  def campioni_dal_2011
    Campione.find(:all,
                  :conditions =>  "cliente_id = #{self.id} AND data >= '2011-01-01 00:00:00'")
  end

  def rapporti_fatturabili
    rapporti_totali = Array.new
    #self.campioni.each do |campione|
    self.campioni_dal_2011.each do |campione|
      campione.rapporti.each do |rapporto|
       (rapporti_totali << rapporto) if (!rapporto.fattura && rapporto.rdp_pronto?)
      end
    end
    return rapporti_totali
  end

  def cancella_pure_dato_che_non_e_utilizzato
    if !self.utilizzato?
      return true
    else
       raise "Non posso cancellare una cliente se utilizzato"
       logger.info( "Tentativo di cancellazione di cliente utilizzato" )
      return false
    end
  end

  def utilizzato?
    if self.campioni.empty? && self.fatture.empty?
      return false
    else
      return true
    end
  end

  def cliente_test?
    return true if self.nome.downcase  =~ / test /
  end

  protected
  
  def validate
    unless codice_fiscale.nil? || codice_fiscale.to_s.size != 16
      errors.add('codice_fiscale', 'formalmente errato') unless ControllaCodiceFiscale.valid?(codice_fiscale)
    end
    unless partita_iva.nil? || partita_iva.to_s.size != 11
      errors.add('partita_iva', 'formalmente errata') unless ControllaPartitaIva.valid?(partita_iva)
    end
  end

end
