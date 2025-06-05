#!/bin/bash

export PYTHONUNBUFFERED=1

# Katalog na pobrane utwory
MUSIC_DIR=~/Spotify_Music
mkdir -p "$MUSIC_DIR"
cd "$MUSIC_DIR" || exit 1

# Wymagane pakiety Debiana
DEB_PACKAGES=("python3" "python3-venv" "python3-pip" "ffmpeg")

# Instalacja brakujących pakietów
for pkg in "${DEB_PACKAGES[@]}"; do
    if ! dpkg -s "$pkg" > /dev/null 2>&1; then
        echo "Pakiet $pkg nie jest zainstalowany. Instaluję..."
        sudo apt-get update && sudo apt-get install -y "$pkg"
    else
        echo "Pakiet $pkg jest już zainstalowany."
    fi
done

# Tworzenie i aktywacja środowiska virtualenv (w katalogu skryptu)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

if [ ! -d "venv" ]; then
    echo "Tworzę środowisko virtualenv..."
    python3 -m venv venv
fi

source venv/bin/activate

# Instalacja spotdl wewnątrz venv
if ! pip list | grep -q spotdl; then
    echo "Instaluję spotdl..."
    pip install --upgrade pip
    pip install spotdl
else
    echo "spotdl już jest zainstalowany w virtualenv."
fi

# Pobieranie muzyki
echo "Wklej link z Spotify (pliki trafią do: $MUSIC_DIR):"
read -r link

if [ -z "$link" ]; then
    echo "Nie podano linku. Kończę."
    exit 1
fi

spotdl "$link"

echo "✅ Gotowe! Sprawdź folder: $MUSIC_DIR"
