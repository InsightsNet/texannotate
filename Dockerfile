FROM ubuntu:bionic

RUN apt-get update

# Set DEBIAN_FRONTEND to disable tzdatainteractive dialogue
ARG DEBIAN_FRONTEND=noninteractive

# Install Perl
# Build-essential is required for installing Perl dependencies
RUN apt-get install -y build-essential
# Old version (e.g., 5.22) needed to support TeX::AutoTeX
# Perl installation will take a very long time.
# Skip running tests for Perl 5.22.5, as version 5.22.4 has a couple minor test failures.
RUN apt-get install -y curl
RUN cpan App::perlbrew
RUN perlbrew init
RUN perlbrew --notest install perl-5.22.4
RUN perlbrew install-cpanm

# Install LaTeX suite
# This download will take an extremely long time to install, so we install it first
RUN apt-get install -y wget
RUN wget https://arxiv-web-static1.s3.amazonaws.com/semantic_scholar_20210412/arXivTeXLive2020.tar.gz
RUN tar -xf arXivTeXLive2020.tar.gz
RUN echo "I" | perl 2020/install-tl
RUN rm -r arXivTeXLive2020.tar.gz 2020

# Install AutoTeX TeX compilation library
SHELL ["/bin/bash", "-c"]
RUN source ~/perl5/perlbrew/etc/bashrc \
  && perlbrew use perl-5.22.4 \
  && cpanm TeX::AutoTeX

# Install Python
RUN apt-get install -y python3.7
RUN apt-get install -y python3-distutils
RUN apt-get install -y python3.7-dev
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1
RUN python get-pip.py --force-reinstall

# Install pip requireements
COPY requirements.txt ./
RUN pip install -r requirements.txt

# Copy over the source code
WORKDIR /sources
COPY . .

CMD ["uvicorn", "service:app", "--host", "0.0.0.0", "--port", "80"]
