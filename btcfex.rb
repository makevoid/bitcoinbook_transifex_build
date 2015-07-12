require_relative 'config/env'

def write(file, contents)
  File.open(file, "w"){ |f| f.write contents }
end

puts "fetching translations"

transifex = Transifex::Client.new
project   = transifex.project PROJECT_SLUG

project.resources.each do |resource|
  puts "Translation: #{resource.slug}"

  # project.resource(resource.slug) # => Transifex::Resource object
  # res = project.resource(resource.slug)
  #
  lang    = :it
  content = resource.translation lang

  content = content.content

  puts "content: - lang: #{lang}"
  puts content

  path    = "public/#{lang}/#{resource.slug}.html"
  full_path = "#{PATH}/#{path}"
  write full_path, content

  puts `docker run -ti -v #{full_path} --rm  asciidoc ls /home/makevoid` # asciidoc

  exit
  # raise content.inspect

  # raise res.translation(:it).inspect
end


puts
puts "building pdfs"

puts
puts "publishing"
