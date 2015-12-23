# Transifex > Asciidoc build system
# for aantonop/Bitcoinbook

Simple web UI + Render Tool

Renders HTML/PDF files of the latest version present on transifex


the files are converted

to see some translations right check the 'with_translations' branch

### Setup

Install docker (http://docs.docker.com/mac/started) then:

    docker pull makevoid/asciidoc


https://hub.docker.com/u/makevoid/asciidoc


### Building

    rake

### Run

    rake run

or

    bin/asciifex


### Console


  irb -r ./config/env.rb



### Direct urls

Direct translation download urls (you need to be logged in):

    https://www.transifex.com/projects/p/mastering-bitcoin/resource/preface/l/LANG/download/for_use/


for available LANGs see lib/languages.


### PDF

for single pdfs you need pdfunite part of poppler-utils

    apt-get install poppler-utils

---

enjoy

by @makevoid - http://github.com/makevoid?tab=repositories
