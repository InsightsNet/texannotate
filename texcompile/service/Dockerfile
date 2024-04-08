FROM texlive/texlive:latest

RUN apt-get update

# Set DEBIAN_FRONTEND to disable tzdatainteractive dialogue
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq

# Install Perl
# Build-essential is required for installing Perl dependencies
RUN apt-get install -y build-essential
# Old version (e.g., 5.22) needed to support TeX::AutoTeX
# Perl installation will take a very long time.
# Skip running tests for Perl 5.22.5, as version 5.22.4 has a couple minor test failures.
#RUN apt-get install -y curl
RUN cpan App::perlbrew
RUN perlbrew init
RUN perlbrew --notest install perl-5.22.4
RUN perlbrew install-cpanm

# Install Python
RUN apt-get install -y python3-pip
#RUN apt-get install -y python3-distutils
#RUN apt-get install -y python3.7-dev
#RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
#RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1
#RUN python get-pip.py --force-reinstall

# Install pip requireements
COPY requirements.txt ./
RUN pip install -r requirements.txt --break-system-packages

# Install AutoTeX TeX compilation library
SHELL ["/bin/bash", "-c"]
RUN source ~/perl5/perlbrew/etc/bashrc \
  && perlbrew use perl-5.22.4 \
  #&& cpanm TeX::AutoTeX
  && cpanm https://github.com/Fireblossom/TeX-AutoTeX-Mod.git

## Copy and mod from ar5ivist-base, using a fixed LaTeXML commit
# latexml dependencies
RUN apt-get install -qy \
  #git \
  imagemagick \
  libarchive-zip-perl \
  libdb-dev \
  libfile-which-perl \
  libimage-magick-perl \
  libimage-size-perl \
  libio-string-perl \
  libjson-xs-perl \
  libparse-recdescent-perl \
  libtext-unidecode-perl \
  liburi-perl \
  libuuid-tiny-perl \
  libwww-perl \
  libxml-libxml-perl \
  libxml-libxslt-perl \
  libxml2 libxml2-dev \
  libxslt1-dev libxslt-dev \
  libxslt1.1 \
  liblocal-lib-perl \
  make 
  
# Install LaTeXML, at a fixed commit, via cpanminus
#RUN mkdir -p /opt/latexml
#WORKDIR /opt/latexml
# ENV LATEXML_COMMIT=ae2c8b266d1aa04af4350a64c79215bbe4b7c482
#RUN source ~/perl5/perlbrew/etc/bashrc \
  #&& perlbrew use perl-5.22.4 \ 
  #&&cpanm --notest --verbose https://github.com/brucemiller/LaTeXML/tarball/$LATEXML_COMMIT
  #&& cpanm XML::LibXSLT \
  #&& cpanm LaTeXML

# LaTeXML v0.8.8 cannot running on perl-5.22.4, use apt's
# which is also v0.8.8
RUN apt-get install -y latexml

# Enable imagemagick policy permissions for work with arXiv PDF/EPS files
RUN perl -pi.bak -e 's/rights="none" pattern="([XE]?PS\d?|PDF)"/rights="read|write" pattern="$1"/g' /etc/ImageMagick-6/policy.xml
# Extend imagemagick resource allowance to be able to create with high-quality images
RUN perl -pi.bak -e 's/policy domain="resource" name="width" value="(\w+)"/policy domain="resource" name="width" value="126KP"/' /etc/ImageMagick-6/policy.xml
RUN perl -pi.bak -e 's/policy domain="resource" name="height" value="(\w+)"/policy domain="resource" name="height" value="126KP"/' /etc/ImageMagick-6/policy.xml
RUN perl -pi.bak -e 's/policy domain="resource" name="area" value="(\w+)"/policy domain="resource" name="area" value="2GiB"/' /etc/ImageMagick-6/policy.xml
RUN perl -pi.bak -e 's/policy domain="resource" name="disk" value="(\w+)"/policy domain="resource" name="disk" value="8GiB"/' /etc/ImageMagick-6/policy.xml
RUN perl -pi.bak -e 's/policy domain="resource" name="memory" value="(\w+)"/policy domain="resource" name="memory" value="2GiB"/' /etc/ImageMagick-6/policy.xml
RUN perl -pi.bak -e 's/policy domain="resource" name="map" value="(\w+)"/policy domain="resource" name="map" value="2GiB"/' /etc/ImageMagick-6/policy.xml

ENV MAGICK_DISK_LIMIT=2GiB
ENV MAGICK_MEMORY_LIMIT=512MiB
ENV MAGICK_MAP_LIMIT=1GiB
ENV MAGICK_TIME_LIMIT=900
ENV MAGICK_TMPDIR=/dev/shm
ENV TMPDIR=/dev/shm

# Copy over the source code
WORKDIR /sources
COPY . .
RUN echo 'alias pdflatex="pdflatex -interaction=nonstopmode"' >> ~/.bashrc
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]
