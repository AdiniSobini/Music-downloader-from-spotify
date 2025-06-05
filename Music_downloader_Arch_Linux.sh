#!/bin/bash

export PYTHONUNBUFFERED=1

# Tworzenie katalogu na muzykę (jeśli nie istnieje)
MUSIC_DIR=~/Spotify_Music
mkdir -p "$MUSIC_DIR"
cd "$MUSIC_DIR" || exit 1

# Sprawdź, czy zainstalowany jest python
if ! pacman -Qs python > /dev/null 2>&1; then
    echo "Python nie jest zainstalowany. Instaluję..."
    sudo pacman -S --noconfirm python
else
    echo "Pakiet Python jest już zainstalowany."
fi

# Sprawdź, czy zainstalowany jest ffmpeg
if ! pacman -Qs ffmpeg > /dev/null 2>&1; then
    echo "Pakiet ffmpeg nie jest zainstalowany. Instaluję..."
    sudo pacman -S --noconfirm ffmpeg
else
    echo "Pakiet ffmpeg jest już zainstalowany."
fi

# Przejście do katalogu ze skryptem
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

# Utwórz środowisko virtualenv jeśli nie istnieje
if [ ! -d "venv" ]; then
    echo "Tworzę środowisko virtualenv..."
    python -m venv venv
fi

# Aktywuj virtualenv
source venv/bin/activate

# Zainstaluj spotdl jeśli nie jest zainstalowany
if ! pip list | grep -q spotdl; then
    echo "Instaluję spotdl..."
    pip install spotdl
else
    echo "spotdl jest już zainstalowane w virtualenv."
fi

# Pobieranie muzyki
echo "Podaj link do playlisty/traku z Spotify (pliki trafią do: $MUSIC_DIR):"
read -r link

if [ -z "$link" ]; then
    echo "Nie podano linku. Kończę działanie."
    exit 1
fi

spotdl "$link"

echo "✅ Gotowe! Sprawdź folder $MUSIC_DIR"
