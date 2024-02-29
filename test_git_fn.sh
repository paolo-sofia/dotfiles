#!/bin/sh

cd ~/git || exit

gitclone()
{
  URL=$2
  FOLDER=$1
  if [ ! -d "$FOLDER" ] ; then
      git clone "$URL" "$FOLDER"
  fi
}


gitclone auto-cpufreq https://github.com/AdnanHodzic/auto-cpufreq.git
gitclone dotfiles https://github.com/paolo-sofia/dotfiles.git
gitclone background-setter https://github.com/paolo-sofia/background-setter.git
gitclone amd-sfh-hid-dkms-asus https://github.com/paolo-sofia/amd-sfh-hid-dkms-asus.git
