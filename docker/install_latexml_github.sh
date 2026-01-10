#!/usr/bin/env bash
set -euo pipefail

# Install LaTeXML from GitHub (latest by default).
#
# Build args / env:
#   LATEXML_REPO (default: https://github.com/brucemiller/LaTeXML.git)
#   LATEXML_REF  (default: master)

export DEBIAN_FRONTEND=noninteractive

LATEXML_REPO="${LATEXML_REPO:-https://github.com/brucemiller/LaTeXML.git}"
# Empty means: use the repo default branch (GitHub latest).
LATEXML_REF="${LATEXML_REF:-}"

if ! command -v apt-get >/dev/null 2>&1; then
  echo "Error: apt-get not found; cannot install LaTeXML dependencies" >&2
  exit 2
fi

apt-get update
apt-get install -y --no-install-recommends \
  ca-certificates \
  git \
  perl \
  cpanminus \
  make \
  gcc \
  g++ \
  pkg-config \
  libxml2-dev \
  libxslt1-dev \
  zlib1g-dev \
  uuid-dev \
  libssl-dev \
  libxml-libxml-perl \
  libxml-libxslt-perl
rm -rf /var/lib/apt/lists/*

rm -rf /tmp/latexml-src
if [[ -z "${LATEXML_REF}" ]]; then
  git clone --depth 1 "${LATEXML_REPO}" /tmp/latexml-src
else
  if git clone --depth 1 --branch "${LATEXML_REF}" "${LATEXML_REPO}" /tmp/latexml-src 2>/dev/null; then
    :
  else
    git clone "${LATEXML_REPO}" /tmp/latexml-src
    (cd /tmp/latexml-src && git checkout "${LATEXML_REF}")
  fi
fi

cd /tmp/latexml-src
cpanm --notest --installdeps .
perl Makefile.PL
make -j"$(nproc)"
# Precompile L3 kernel (expl3) for faster runtime performance.
# This takes ~10 minutes but significantly speeds up packages using expl3.
make formats
make install


cd /
rm -rf /tmp/latexml-src

command -v latexmlc >/dev/null 2>&1
latexmlc --version || true
