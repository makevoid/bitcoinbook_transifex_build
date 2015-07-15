module CheckConnection
  def self.check_connection
    puts "checking for internet connection"
    Resolv::DNS.new().getaddress "opendns.com"
    # Hashie::Mash.new( connection: "active" )
    { connection: "active" }
  rescue Resolv::ResolvError => e
    puts "internet connection not found"
    puts "exiting...."
    exit
  end
end
