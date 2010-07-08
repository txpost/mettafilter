# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_madlib_session',
  :secret      => 'c8ed5a07a01901d510a91ecc6052647c2641f0fec460db893b393a0c73981711dd60bd566ec645cc430908cd8a432d4c015c9e40cca3ffdee47210a9e8c1d8cd'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
