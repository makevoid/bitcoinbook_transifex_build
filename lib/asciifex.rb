require_relative '../config/env'
require_relative 'languages'

def write(file, contents)
  File.open(file, "w"){ |f| f.write contents }
end

def public_path(lang)
  "#{PATH}/public/#{lang}"
end

def convert(resource:, lang:, content:)
  filename  = "#{resource}.asciidoc"

  write "#{public_path lang}/#{filename}", content

  docker_path = "/home/makevoid/apps/asciidoc"
  cmd = "asciidoc #{docker_path}/#{filename}"
  puts `docker run -ti -v #{public_path lang}:#{docker_path} --rm  makevoid/asciidoc #{cmd}`
end

def project
  return @project if @project

  transifex = Transifex::Client.new
  @project  = transifex.project PROJECT_SLUG
end

def asciifex
  puts "Fetching translations"

  # languages = get_languages project
  languages = LANGUAGES

  languages.each do |lang|
    puts `mkdir -p #{public_path(lang)}`
  end

  project.resources.each do |resource|
    puts "Translation: #{resource.slug}"

    languages.each do |lang|

      ## TODO: ######
      # wrap in a celluloid object/method - call async on it - run 10 in parallel
      content = resource.translation lang
      content = content.content
      puts "Content: - lang: #{lang}"
      # puts content
      slug  = resource.slug
      convert resource: slug, lang: lang, content: content
      ###############

    end

    # exit
  end

  puts
  puts "publishing to S3"
end



# -------
#


# Run:
#
#   asciifex
#




##
# transifex infos

# project.resource(resource.slug) # => Transifex::Resource object
# res = project.resource(resource.slug)
#


### unused methods


# def get_languages(project)
#   # Transifex::Languages.fetch
#   # []
#
#   project.languages # not enough permissions
# end
