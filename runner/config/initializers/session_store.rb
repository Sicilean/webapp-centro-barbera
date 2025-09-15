# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_runner_session',
  :secret      => '91cdfb102689b1c7907623a7b09c2833f62aef34b242663fa5bfb3f6a35a326499baf69909ee0924512e1b34bab9faa2749361ed47d10fc939125286ac81e79b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
