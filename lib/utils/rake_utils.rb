require_relative "check_connection"

module RakeUtils
  include CheckConnection

  def this
    self.class
  end
end
