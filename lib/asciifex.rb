require_relative '../config/env'
require_relative 'languages'

def write(file, contents)
  File.open(file, "w"){ |f| f.write contents }
end

def public_path(lang)
  "#{PATH}/public/translations/#{lang}"
end

def convert(resource:, lang:, content:)
  filename  = "#{resource}.asciidoc"

  write "#{public_path lang}/#{filename}", content

  docker_path = "/home/makevoid/apps/asciidoc"
  cmd = "asciidoc #{docker_path}/#{filename}"
  docker = "docker run -ti -v #{public_path lang}:#{docker_path} --rm  makevoid/asciidoc #{cmd}"
  puts "executing: #{docker}"
  puts `#{docker}`
end

def project
  return @project if @project

  transifex = Transifex::Client.new
  @project  = transifex.project PROJECT_SLUG
end

def asciifex
  puts "Fetching translations"

  languages = LANGUAGES
  languages.each do |lang|
    `mkdir -p #{public_path(lang)}`
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

  end

  puts
end

puts "build finished"

# DEBUG:

# docker run -ti -v /home/makevoid/apps/bitcoinbook_transifex_build/public/translations/en:/home/makevoid/apps/asciidoc --rm  makevoid/asciidoc asciidoc /home/makevoid/apps/asciidoc/appendix-bips.asciidoc

# docker run -ti -v /home/makevoid/apps/bitcoinbook_transifex_build/public/translations/en:/home/makevoid/apps/asciidoc --rm  makevoid/asciidoc a2x --fop /home/makevoid/apps/asciidoc/appendix-bips.asciidoc
