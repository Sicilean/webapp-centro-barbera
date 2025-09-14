# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

# Create an admin user
User.create!(
  nome: 'Admin',
  role: 1, # Assuming 1 is admin role
  email: 'info@centrobarbera.it',
  password: 'barbera2025',
  password_confirmation: 'barbera2025'
)

# Create basic parameters if needed
Parametro.create!(
  codice: 'numero_fattura',
  nome: 'Numero Fattura',
  valore: '1'
) unless Parametro.find_by_codice('numero_fattura')

Parametro.create!(
  codice: 'numero_campione',
  nome: 'Numero Campione',
  valore: '1'
) unless Parametro.find_by_codice('numero_campione')

# You can add more essential seed data here if needed
