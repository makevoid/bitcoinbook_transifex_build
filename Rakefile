require "resolv"
require_relative "lib/utils/rake_utils"

task default: :run

class App
  extend RakeUtils

  def self.run(rake)
    puts `mdkir -p ./public/translations`
    rake.send :ruby, "bin/asciifex"
  end

  def self.build
    this.check_connection # only needed if building from rubygems.org
    this.do_build
  end

  def self.do_build
    puts `bundle install`
  end
end

task :build do
  App.build
end

task :run do
  App.run(self)
end
