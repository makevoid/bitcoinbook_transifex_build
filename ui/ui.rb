# env_ui

require_relative "../config/env"
Bundler.require :ui

require_relative '../lib/languages'

module AsciiFex
  class UI < Sinatra::Base

    set public: "#{PATH}/public"

    helpers do
      include Haml::Helpers

      def languages
        LANGUAGES
      end

      def lang_full(lang)
        LANGUAGES_FULL[ LANGUAGES.index(lang) ]
      end

      def sections
        %w(
          appendix-bips appendix-bx appendix-pycoin appendix-script-ops chapter-10
          chapter-1 chapter-2 chapter-3 chapter-4 chapter-5 chapter-6 chapter-7
          chapter-8 chapter-9 glossary index praise preface.html
        )
      end
    end

    get "/" do
      haml :index
    end

    get "/asciidoc/:lang/:name" do |lang, name|
      content_type "text/plain"
      path = "#{PATH}/public/translations/#{lang}/#{name}.asciidoc"
      # send_file path, type: "text/plain", filename: "#{lang}-#{name}.txt"
      File.read path
    end

    get "/translations/:lang/images/:file" do |_, file|
      path = "#{PATH}/public/images/#{file}"
      send_file path, type: "image/png"
    end

    get "/translations/:lang/code/:file" do |_, file|
      path = "#{PATH}/public/code/#{file}"
      send_file path, type: "text/plain"
    end
  end
end
