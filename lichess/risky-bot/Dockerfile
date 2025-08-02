# Basisimage mit Python
FROM python:3.11-slim

# Installiere benötigte Pakete
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Arbeitsverzeichnis setzen
WORKDIR /app

# Python requirements kopieren
COPY requirements.txt .

# Python-Abhängigkeiten installieren
RUN pip install --no-cache-dir -r requirements.txt

# Stockfish herunterladen und entpacken
RUN wget  https://github.com/official-stockfish/Stockfish/releases/latest/download/stockfish-ubuntu-x86-64-avx2.tar \
    && tar xvf stockfish-ubuntu-x86-64-avx2.tar  \
    && chmod +rx stockfish \
    && rm stockfish-ubuntu-x86-64-avx2.tar

# Anwendungscode kopieren
COPY . .

# Umgebungsvariable setzen (Pfad zu Stockfish)
ENV STOCKFISH_PATH=/app/stockfish/stockfish-ubuntu-x86-64-avx2 

# Starte dein Bot-Script mit "unbuffered" option
CMD ["python", "-u", "bot.py"]

