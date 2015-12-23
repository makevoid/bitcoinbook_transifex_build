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

  # asciidoc for HTML
  docker_path = "/home/makevoid/apps/asciidoc"
  cmd = "asciidoc #{docker_path}/#{filename}"
  docker = "docker run -ti -v #{public_path lang}:#{docker_path} --rm  makevoid/asciidoc #{cmd}"
  puts "executing: #{docker}"
  puts `#{docker}`


  # asciidoctor for PDF
  #
  # symlink included files
  puts `cd #{public_path lang} && ln -sf #{PATH}/public/images`
  puts `cd #{public_path lang} && ln -sf #{PATH}/public/code`
  #
  asciidoctor = "asciidoctor -r asciidoctor-pdf -b pdf #{public_path lang}/#{filename}"
  puts "executing: #{asciidoctor}"
  puts `#{asciidoctor}`
end

def project
  return @project if @project

  transifex = Transifex::Client.new
  @project  = transifex.project PROJECT_SLUG
end

def execute_one(resource: resource)
  LANGUAGES.each do |lang|
    content = resource.translation lang
    content = content.content # ...

    # puts content # for debug
    puts "Content: - lang: #{lang}"
    slug  = resource.slug
    convert resource: slug, lang: lang, content: content
  end
end

def execute_worker_on(queue: queue)
  begin
    while job = queue.pop(true)
      resource = job
      puts "Translation: #{resource.slug}"
      execute_one resource: resource
    end
  rescue ThreadError => e
    "Error in thread: #{e}"
  end
end

def asciifex
  puts "Fetching translations"

  LANGUAGES.each do |lang|
    `mkdir -p #{public_path(lang)}`
  end

  jobs = project.resources

  require 'thread'
  queue = Queue.new
  jobs.each{ |job| queue.push job }

  workers = (0...8).map do
    Thread.new do
      execute_worker_on queue: queue
    end
  end
  workers.map &:join

  # TODO extract in function
  # join pdfs
  LANGUAGES.each do |lang|
    resources = ["praise", "index", "preface", "glossary-1", "chapter-1", "chapter-2", "chapter-3", "chapter-4", "chapter-5", "chapter-6", "chapter-7", "chapter-8", "chapter-9",  "chapter-10", "appendix-bx", "appendix-bips",  "appendix-pycoin", "appendix-script-ops" ]
    # raise project.resources.map(&:slug).inspect
    resources = resources.join ".pdf "
    puts `cd #{public_path(lang)} && pdfunite #{resources}.pdf book.pdf`
  end

  puts "build finished"
end


# DEBUG:

# generic
#
# docker run -ti -v /home/YOUR_USER/apps/bitcoinbook_transifex_build/public/translations/en:/home/YOUR_USER/apps/asciidoc --rm  makevoid/asciidoc asciidoc /home/YOUR_USER/apps/asciidoc/appendix-bips.asciidoc

# w/ my user
#
# docker run -ti -v /home/makevoid/apps/bitcoinbook_transifex_build/public/translations/en:/home/makevoid/apps/asciidoc --rm  makevoid/asciidoc asciidoc /home/makevoid/apps/asciidoc/appendix-bips.asciidoc
#
# docker run -ti -v /home/makevoid/apps/bitcoinbook_transifex_build/public/translations/en:/home/makevoid/apps/asciidoc --rm  makevoid/asciidoc a2x --fop /home/makevoid/apps/asciidoc/appendix-bips.asciidoc
