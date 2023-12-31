FROM texlive/texlive:latest

RUN apt-get update

# Set DEBIAN_FRONTEND to disable tzdatainteractive dialogue
ARG DEBIAN_FRONTEND=noninteractive

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

# Install LaTeX suite
#COPY texlive.tar.gz texlive.tar.gz
#RUN tar -xf texlive.tar.gz
#RUN echo "I" | perl 2020/install-tl
#RUN rm -r texlive.tar.gz 2020

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

# Copy over the source code
WORKDIR /sources
COPY . .
RUN echo 'alias pdflatex="pdflatex -interaction=nonstopmode"' >> ~/.bashrc
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]
