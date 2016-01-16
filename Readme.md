# Transifex > Asciidoc build system
# for aantonop/Bitcoinbook

Simple web UI + Render Tool

Renders HTML/PDF files of the latest version present on transifex


the files are converted

to see some translations right check the 'with_translations' branch

### Setup

Clone the project, copy the default configuration file from `config/transifex.default.txt` to `config/transifex.txt`, put your Transifex username and password in (Transifex should really use API keys instead of user credentials :/) and save the file.

Install docker (http://docs.docker.com/mac/started) then:

    docker pull makevoid/asciidoc

asciidoc container available at: https://hub.docker.com/u/makevoid/asciidoc

then

    gem install bundle

### Building

    bundle

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
    

#### Complete setup from a fresh ubuntu:14.04 machine

as root:

```
apt-get update

# install some tools
apt-get install -y git-core wget vim

# install packages for ruby
apt-get install -y build-essential libreadline-dev libssl-dev libtinfo-dev libyaml-dev libzlcore-dev

# install ruby from source
mkdir -p ~/tmp
cd ~/tmp
wget https://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.0.tar.gz
tar xvf ruby-2.3.0.tar.gz 
cd ruby-2.3.0
./configure && make && make install

# install bundler
gem i bundler

# clone the repo
mkdir -p /www
cd /www
git clone https://github.com/makevoid/bitcoinbook_transifex_build
cd /www/bitcoinbook_transifex_build
bundle
cp config/transifex.default.txt config/transifex.txt
vim config/transifex.txt
# ------------------------------------------
# enter your transifex username and password 
# ------------------------------------------

# install docker
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list

apt-get update -y
apt-get install -y  linux-image-extra-$(uname -r)
# --------------------------------------
# continue without installing grub
# --------------------------------------
apt-get install -y docker-engine
service docker restart
docker run hello-world # to test docker is working


# install pdfunite
apt-get install -y poppler-utils

# run the building task
cd /www/bitcoinbook_transifex_build
rake

# then to launch the test server
rackup -o 0.0.0.0

# and visit http://your_host:9292
```

I will follow up with more infos for complete setup with a real web server

---

enjoy

by @makevoid - http://github.com/makevoid?tab=repositories
