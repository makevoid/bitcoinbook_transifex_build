require 'bundler/setup'
Bundler.require :default

Transifex.configure do |c|
  c.client_login  = 'your_client_login'
  c.client_secret = 'your_secret'
end
