#!/bin/bash


export PYTHONUNBUFFERED=1

cd ~ && mkdir Spotify_Music
cd Spotify_Music

PACKAGE_NAME="python3"
PACKAGE_NAME3="ffmpeg"

if dpkg -s $PACKAGE_NAME > /dev/null 2>&1 ; then
    echo "The $PACKAGE_NAME package is already installed"
else
    echo "The $PACKAGE_NAME package is not installed. Install..."
    sudo apt-get update && sudo apt-get install -y $PACKAGE_NAME
fi

if pip3 list | grep -q spotdl ; then
    echo "spotdl is already installed"
else
    echo "Ok You don't have spotdl, but don't worry I will install"
    python3 -m pip install spotdl
fi

if dpkg -s $PACKAGE_NAME3 > /dev/null 2>&1 ; then
    echo "The $PACKAGE_NAME3 package is already installed"
else
    echo "The $PACKAGE_NAME3 package is not installed. Install..."
    sudo apt-get update && sudo apt-get install -y $PACKAGE_NAME3
fi

echo "Ok, you can paste your link from Spotify now (Your music will be in /home/user/Spotify_Music):"
read link
python3 -m spotdl $link
sleep 1
echo "Ok, everything is ready. Enjoy your music! 😁"
