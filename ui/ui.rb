# env_ui

require_relative "../config/env"
Bundler.require :ui

require_relative '../lib/languages'

module AsciiFex
  class UI < Sinatra::Base

    helpers do
      include Haml::Helpers

      def languages
        LANGUAGES
      end

      def sections
        %w(
          appendix-bips appendix-bx appendix-pycoin appendix-script-ops chapter-10
          chapter-1 chapter-2 chapter-3 chapter-4 chapter-5 chapter-6 chapter-7
          chapter-8 chapter-9 glossary index praise preface.html
        )
      end

      # alias :c :haml_concat
      # alias :t :haml_tag


      def sections_html
        languages.map do |lang|
          haml_concat lang
          # t(:h1){ c "Language: #{it}" }
          # t :ul do
          #   sections.map do |section|
          #     t :li do
          #       t(:a){ c "Language: #{it}" }
          #     end
          #   end
          # end

          # lang
        end
      end
    end

    get "/" do
      "
      langs: #{LANGUAGES}
      <br>
      <br>
      translations
      <br>
      #{sections_html}
      <br>
      <br>
      "
    end
  end
end
