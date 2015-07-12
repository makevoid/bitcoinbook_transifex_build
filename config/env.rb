path = File.expand_path "../../",  __FILE__
PATH = path

require 'bundler/setup'
Bundler.require :default

PROJECT_SLUG = "mastering-bitcoin"


file = File.read "#{path}/config/transifex.txt"
login, secret = file.split "|"

Transifex.configure do |c|
  c.username = login
  c.password = secret.strip
end
