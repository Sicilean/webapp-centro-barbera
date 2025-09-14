# Configurazione dell'amministratore predefinito
# Questo script verifica l'esistenza dell'utente amministratore
# e lo crea se non esiste.

# Credenziali predefinite
DEFAULT_ADMIN_EMAIL = 'info@centrobarbera.it'
DEFAULT_ADMIN_PASSWORD = 'barbera2025'
ADMIN_ROLE = 10 # Ruolo amministratore (definito in environment.rb)

Rails.logger.info "Verificando l'esistenza dell'utente amministratore predefinito..."

# Cerca l'utente amministratore per email
unless User.find_by_email(DEFAULT_ADMIN_EMAIL)
  # Se l'utente non esiste, lo creiamo
  admin = User.new(
    :email => DEFAULT_ADMIN_EMAIL,
    :password => DEFAULT_ADMIN_PASSWORD,
    :password_confirmation => DEFAULT_ADMIN_PASSWORD,
    :nome => 'Amministratore',
    :role => ADMIN_ROLE
  )
  
  if admin.save
    Rails.logger.info "Utente amministratore predefinito creato con successo."
  else
    Rails.logger.error "Errore durante la creazione dell'utente amministratore predefinito: #{admin.errors.full_messages.join(', ')}"
  end
else
  # Aggiorna la password dell'amministratore esistente
  admin = User.find_by_email(DEFAULT_ADMIN_EMAIL)
  admin.password = DEFAULT_ADMIN_PASSWORD
  admin.password_confirmation = DEFAULT_ADMIN_PASSWORD
  if admin.save
    Rails.logger.info "Password dell'utente amministratore predefinito aggiornata con successo."
  else
    Rails.logger.error "Errore durante l'aggiornamento della password dell'utente amministratore: #{admin.errors.full_messages.join(', ')}"
  end
end 