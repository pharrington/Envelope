# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_webmail_session',
  :secret      => 'faabc6cf4e737f2bfd8d40501e405880cf97a2dededddb3d34141cadf833f75aac480de468cb729472bbb35256261242a509fabfdc123dd79ff1a7b08c3fe4b2'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
