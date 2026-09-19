FROM node:22-bookworm-slim

WORKDIR /automation

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    git \
    curl \
    wget \
    unzip \
    libglib2.0-0 \
    libnss3 \
    libnspr4 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libdbus-1-3 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libxkbcommon0 \
    libasound2 \
    libpango-1.0-0 \
    libcairo2 \
    && rm -rf /var/lib/apt/lists/*

RUN ln -sf /usr/bin/python3 /usr/local/bin/python && \
    ln -sf /usr/bin/pip3 /usr/local/bin/pip

COPY requirements.txt .

RUN pip install --no-cache-dir --break-system-packages -r requirements.txt

RUN rfbrowser init

COPY . .

RUN mkdir -p results

CMD ["tail", "-f", "/dev/null"]