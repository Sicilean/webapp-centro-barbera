# MODELLI
xx/xx xx:xx #


# FATTURE

script/generate scaffold Fattura \
cliente_id:integer \
numero:integer \
data_emissione:date \
totale:float \
data_inizio:date \
data_fine:date \
data_pagamento:date \




#
# PARAMETRO

id
codice:string
nome:string
note:string
valore:text

script/generate scaffold Parametro codice:string nome:string note:string valore:text



# Matrice

  has_many :campioni  # campione.matrice  matrice.campione
  has_many :prove    # matodo.matrice   matrice.prove
  has_many :tipologie
  has_many :variabili

id
nome:string  #(es. 'suolo', 'olio', 'vino', ...)
nome_esteso:string

script/generate scaffold Matrice nome:string nome_esteso:string



# Prova

  belongs_to :matrice
  #
  has_many :prova_variabile_items
  has_many :variabili, :through => :prova_variabile_items
  #
  has_many :prova_tipologia_items
  has_many :tipologie, :through => :prova_tipologia_items
  #
#
#  has_many :campione_prova_items
#  has_many :campioni,  :through => :campione_prova_items


  has_many :prova_rapporto_items
  has_many :rapporti, :through => :prova_rapporto_items

id
matrice_id:integer
nome:string  #(es. conduttività elettrica, oppure 'generale')
nome_esteso:string
metodo_di_prova:string
subappalto:boolean # si, no
prezzo:float
note:string

script/generate scaffold Prova matrice_id:integer nome:string nome_esteso:string metodo_di_prova:string subappalto:boolean prezzo:float  note:string


# Udm_item

  has_many :variabili

id
nome:string

script/generate scaffold Udm_item nome:string


# Variabile

  belongs_to :udm_item
  belongs_to :matrice
  #
  has_many :prova_variabile_items
  has_many :prove, :through => :prova_variabile_items

  has_many :variabile_rapporto_items
  has_many :rapporti, :through => :variabile_rapporto_items

id
matrice_id:integer
udm_item_id:integer
#categoria:string     # es. 'sorgente (input) => non c'e funzione', 'funzione/risultato (output) => c'e funzione', 'input/output testo => classe:string (non c'e' funzione)'
nome:string           # es. 'Ph'
nome_esteso:string    # es. 'Valore del PH'
simbolo:string        # es. 'AB'
funzione:string       # es. 'A+B' (solo se matrice == 'output valore'), da chiedere solo se
tipo:string           # float, integer, string
min:float             # per stringa potrebbe essere la lunghezza
max:float
decimali:integer
forza_zero:boolean
note:string

script/generate scaffold Variabile udm_item_id:integer nome:string nome_esteso:string simbolo:string \
   funzione:string tipo:string  \
   min:float max:float decimali:integer forza_zero:boolean note:string


# Prova_variabile_item

# (una prova può implicare tante variabili ed una variabile appartiene a tanti prove)
# (mi permette di avere
#                       variabile.prove
#                       prova.variabili...

  belongs_to :prova
  belongs_to :variabile

prova_id:integer
variabile_id:integer
da_mostrare:boolean    # se è una variabile da mostrare al cliente (o se è una formula intermedia)

script/generate scaffold Prova_variabile_item prova_id:integer variabile_id:integer da_mostrare:boolean



# Tipologia

  belongs_to :matrice
#  has_many :campione_tipologia_items
#  has_many :campioni, :through => :campione_tipologia_items
#
  has_many :prova_tipologia_items
  has_many :prove, :through => :prova_tipologia_items

  has_many :rapporti
  has_many :campioni, :through => :rapporti


id
matrice_id:integer
nome:string
nome_esteso:string
forfeit:boolean
prezzo:float
note:string

script/generate scaffold Tipologia matrice_id:integer nome:string nome_esteso:string forfeit:boolean \
 prezzo:float note:string


# Prova_tipologia_item

  belongs_to :prova
  belongs_to :tipologia

prova_id:integer
tipologia_id:integer

script/generate scaffold Prova_tipologia_item prova_id:integer tipologia_id:integer



##################################

# Cliente

  has_many :campioni

id
nome:string
denominazione:string
codice:string
indirizzo:string
cap:string
comune:string
provincia:string
partita_iva:string
codice_fiscale:string
tel:string
fax:string
email:string
cellulare_per_sms:string
titolare_cellulare:string
password:string
note:string

script/generate scaffold Cliente nome:string denominazione:string codice:string indirizzo:string cap:string \
  comune:string provincia:string partita_iva:string codice_fiscale:string tel:string fax:string email:string cellulare_per_sms:string \
  titolare_cellulare:string password:string note:string



# Campione
# (un campione implica uno o più prove)
  #belongs_to :prova
  belongs_to :matrice
  belongs_to :cliente

#  has_many :campione_tipologia_items
#  has_many :tipologie, :through => :campione_tipologia_items
#
#  has_many :campione_prova_items
#  has_many :prove, :through => :campione_prova_items
#
#  has_many :risultati
#  has_many :rapporti
  #

  has_many :rapporti # tipologia_campione_item
  has_many :tipologie, :through => :rapporti

id
matrice_id:integer
cliente_id:integer
etichetta:string
nome_richiedente:string
data_richiesta:datetime
data_scadenza:datetime
numero:integer
#anno:integer
#rdp_numero:integer
#rdp_anno:integer
suggello:string
campionamento:string
non_conforme_motivo:string # non conforme => inserisci testo, conforme => blank
data_invio_email:datetime
data_invio_sms:datetime
status:string
note:string


script/generate scaffold Campione matrice_id:integer cliente_id:integer etichetta:string nome_richiedente:string \
 data_richiesta:datetime data_scadenza:datetime numero:integer \
 suggello:string campionamento:string \
 non_conforme_motivo:string data_invio_email:datetime data_invio_sms:datetime status:string note:string


################


# Rapporto
# Tipologia_campione_item

  belongs_to :tipologia
  belongs_to :campione

  has_many :prova_rapporto_items
  has_many :prove, :through => :prova_rapporto_items

  has_many :variabile_rapporto_items
  has_many :variabili, :through => :variabile_rapporto_items

script/generate scaffold Rapporto \
tipologia_id:integer \
campione_id:integer \
numero:integer \
prezzo:float \
data:date \
note:string \



# prova_rapporto_item
#

  belongs_to :prova
  belongs_to :rapporto


script/generate scaffold Prova_rapporto_item \
prova_id:integer \
rapporto_id:integer \
prezzo:float \





# Risultato
# Variabile_rapporto_item
  belongs_to :variabile
  belongs_to :rapporto


nb. valore_numero #, :precision => 25, :scale => 11,     :default => 0


script/generate scaffold Variabile_rapporto_item \
variabile_id:integer \
rapporto_id:integer \
data:date  \
valore_numero:decimal \
valore_testo:string   \
incertezza_di_misura:string









# script/generate scaffold costanti_item codice:string descrizione:string valore:text
class CreateCostantiItems < ActiveRecord::Migration
  def self.up
    create_table(:costanti_items, :options => 'ENGINE=InnoDB DEFAULT CHARSET=UTF8') do |t|
      t.column :codice,           :string
      t.column :descrizione,      :string
      t.column :valore,           :text #:decimal, :precision => 15, :scale => 10 # :float, :default => 0
      # The precision (totale cifre) represents the number of significant digits that are stored for values, and
      # the scale (cifre dopo la virgola) represents the number of digits that can be stored following the decimal point.
    end
  end

  def self.down
    drop_table :costanti_items
  end
end






#   D A T A B A S E


# USER

#script/generate scaffold user   email:string \
#                                password:string \
#                                azienda:string \
#                                cellulare:string \
#                                notifica_sms:boolean \
#                                note:string \




# poi modifica db/migrate/xxx_create_users

t.string :password ==> t.string :crypted_password

#aggiungi

 t.string :password_salt
 t.string :persistence_token


#poi aggiungi le altre colonne che vuoi:
#es. :last_login_ip ecc...
#vedi http://github.com/binarylogic/authlogic_example

es.
    t.string    :email,               :null => false
    t.string    :crypted_password,    :null => false
    t.string    :password_salt,       :null => false
    t.string    :persistence_token,   :null => false

    # altre opzionali
    t.integer   :login_count,         :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
    t.integer   :failed_login_count,  :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
    t.datetime  :last_request_at                                    # optional, see Authlogic::Session::MagicColumns
    t.datetime  :current_login_at                                   # optional, see Authlogic::Session::MagicColumns
    t.datetime  :last_login_at                                      # optional, see Authlogic::Session::MagicColumns
    t.string    :current_login_ip                                   # optional, see Authlogic::Session::MagicColumns
    t.string    :last_login_ip                                      # optional, see Authlogic::Session::MagicColumns

# altri campi per user

t.string    :azienda
t.string    :cellulare
t.string    :notifica_sms   # true/false per attivare/disattivare servizio notifica via sms
t.string    :note







# prova GENERAL ITEM

Originali

#  VINO
N.RC
DATA
CLIENTE
B/R/RS
Note
CORREZIONI
matriceLOGIA RDP
HL/Q.li/LOTTO
n. VASCA

# OLIO
N. RC
DATA
CLIENTE
matrice PRODOTTO
C/DA - CITTA
VASCA
matriceLOGIA RDP

# TERRENO
N.RC
DATA	
Azienda
Agronomo
matricelogia RdP
N. campioni
contrada
città

# FOGLIE
...

# COMUNI
N. RC
DATA *
CLIENTE *
matriceLOGIA RDP
NOTE *



# Domanda per max: metto sempre N.RC. e matriceLOGIA RDP? numero registro campioni
# Domanda per max: i prova sono legati ai tariffari? se non lo sono, cosa lo è? è importante includere fino ad ora nel modello...




"prove Richieste: "
campione.prove.each do "prova"
  print prova.nome_esteso
end

risultati = prova.prova.risultati

risultati.each do |risultato|
  print "#{risultato.variabile.nome} = #{risultato.valore}"
end



Variabili da chiedere

Prova.prove.each do "prova"
  variabili_ids <<  prova.variabili....
end

variabili_ids.uniq!
e chiedi solo quelle che sono di categoria 'input'

assegnale a variabili

Print "inserisci #{variabile.nome_esteso}=" Variabile.new(risultato_id = variabile.id, valore ) ...)



campione.prova.risultato !!!!!!!!!!

campione.prova.nome



EVAL

a=2
b=3
c="b+a"

formula = "a+b+c"
1. c = "b+a" = "#{b}+#{a}"
2. formula = "a+b+c" = "#{a}+#{b}+(#{b}+#{a})"
3. formula = "2+3+(3+2)"
4. risultato = formula.eval # intercettando l'errore

Passi

1. Devo calcolare una Prova, e la prova prevede tante variabili, es. a,b,c
2. Trasformo le funzioni in funzioni sviluppate, ovvero che abbiano come variabili indipendenti NON funzioni
3. Calcolo tutte le variabili necessarie, ovvero tutte le variabili non funzioni + tutte le var indip. delle funzioni sviluppate
4. Se non ho tutti i valori non continuo (e dico che mancano i dati), oppure faccio i conti parziali
5. Ho tutti i dati: sostituisco nelle formule tutti i simboli con i valori delle variabili, es. formula = "2+3+(3+2)"
6. Faccio formula.eval (!)



____

Occio a date in rails
le data sono della classe Timewithzone
le puoi far diventare belle con Record.date.to_s(format = :default)
ove format è:

  :db           # => 2008-12-25 14:35:05
  :number       # => 20081225143505
  :time         # => 14:35
  :short        # => 25 Dec 14:35
  :long         # => December 25, 2008 14:35
  :long_ordinal # => December 25th, 2008 14:35
  :rfc822       # => Thu, 25 Dec 2008 14:35:05 +0000
