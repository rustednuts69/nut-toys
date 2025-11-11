#!/bin/bash

cd
hypridle_conf=".config/hypr/hypridle.conf"

fix_screensaver_times () {
sed -i "s/150/1500/g" "$hypridle_conf"
sed -i "s/300/3000/g" "$hypridle_conf"
sed -i "s/330/3300/g" "$hypridle_conf"
sed -i "s/2.5/25/g" "$hypridle_conf"
sed -i "s/5min/50min/g" "$hypridle_conf"
sed -i "s/5.5min/55min/g" "$hypridle_conf"
}

if [ "$(cat "$hypridle_conf" | tail -n 1)" != "#Fixed" ]; then
  fix_screensaver_times
  echo "#Fixed" >> "$hypridle_conf"
  echo "Screensaver Times Fixed"
  echo ""
  exit
else
  echo "Already fixed the ridiculously short screensaver timers, won't touch"
  echo ""
fi

if [ -z "$(grep 'alias vim' .bashrc)" ]; then
  echo "Creating alias for neovim -> vim"
  echo ""
  echo "alias vim='nvim'" >> .bashrc
else
  echo "Vim alias already exists, won't touch."
  echo ""
fi

if [ "$1" == "-p" ]; then
  if [ -z "$(grep 'alias pacman' .bashrc)" ]; then
    echo "Making pacman automatically --noconfirm everything "
    echo ""
    echo "alias pacman='pacman --noconfirm'" >> .bashrc
  else
    echo "Pacman alias already exists, won't touch."
    echo ""
  fi
  
  if [ -z "$(grep 'alias yay' .bashrc)" ]; then
    echo "Making yay automatically --noconfirm everything "
    echo ""
    echo "alias yay='yay --noconfirm'" >> .bashrc
  else
    echo "Yay alias already exists, won't touch."
    echo ""
  fi

fi


echo "Nothing Left To Fix"
