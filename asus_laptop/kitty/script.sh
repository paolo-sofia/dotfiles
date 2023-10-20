#!/usr/bin/sh

if [ -z "$1" ]; then
	echo "porcodio $1"
	user=paolo
else
	user=$1
fi

ICON_PATH=/home/$user/.local/share/icons/terminal.png

echo "$ICON_PATH"

if [ -z "$ICON_PATH" ]; then
	echo "Error while getting the icon path"
else
	wget https://github.com/igrmk/whiskers/raw/main/whiskers_256x256.png -O $ICON_PATH &> /dev/null
	echo "s/Icon=kitty/Icon=$ICON_PATH/"
	sed -i "s|Icon=kitty|Icon=$ICON_PATH|" /usr/share/applications/kitty.desktop
fi

