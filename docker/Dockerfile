FROM texlive/texlive:TL2022-historic-src

# Disable interactive prompts
ARG DEBIAN_FRONTEND=noninteractive

# Install Python and pip
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt --break-system-packages

# Create working directory
WORKDIR /lpsb

# Copy LPSB injector
COPY lpsb_injector.tex ./

# Copy service code
COPY main.py ./

# Set environment for better LaTeX output
ENV TEXMFHOME=/lpsb/texmf
ENV TMPDIR=/tmp

# Expose port for FastAPI
EXPOSE 80

# Run uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]
