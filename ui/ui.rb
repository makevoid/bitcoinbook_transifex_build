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
          "
          <h1>Language: #{lang}</h1>

          <ul>
            " +
            sections.map do |section|
              url    = "/#{lang}/#{section}"
              gh_url = "https://github.com/makevoid/bitcoinbook_transifex_build/blob/with_translation/public/#{lang}/#{section}.asciidoc"
              "
              <li>
                <section>
                  <h1>
                    <a href='#{url}.html'>#{section}</a>
                    -
                    <a href='#{gh_url}'>GH</a>
                    -
                    <a href='#{url}.asciidoc'>(source)</a>
                  </h1>
                </section>
              </li>
              "
            end.join("\n") + "
          </ul>

          "

          # haml_concat lang

          # t(:h1){ c "Language: #{it}" }
          # t :ul do
          #   sections.map do |section|
          #     t :li do
          #       t(:a){ c "Language: #{it}" }
          #     end
          #   end
          # end

          # lang
        end.join("\n")
      end
    end

    get "/" do
      haml :index
    end
  end
end
