#!/usr/bin/sh

pwd=$(pwd)
cd ~/git
git clone https://github.com/sxyazi/yazi.git
cd yazi
cargo build --release

apt=$(which apt)

if [[ $apt == *"no apt in"* ]]; then
	dnf=$(which dnf)
	if [[ $apt == *"no dnf in"* ]]; then
		exit
	else
		dnf install ffmpegthumbnailer unar jq poppler fd-find ripgrep fzf zoxide wlroots wlroots-devel
	fi
else
	apt install ffmpegthumbnailer unar jq poppler* fd-find ripgrep fzf zoxide libwlroots*
fi

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/ShareTechMono.zip &> /dev/null

FONT_DIR=~/.fonts/ShareTechMono/
mkdir -p $FONT_DIR

unzip -q ShareTechMono.zip -d $FONT_DIR
rm ShareTechMono.zip

wget https://apps.gnome.org/icons/scalable/org.gnome.Nautilus.svg -O ~/.local/share/icons/yazi.png &> /dev/null
version=$(grep -oP 'version\s*=\s*"\K[^"]+' app/Cargo.toml | head -1)
sed -i "s/<version>/$version/" yazi.desktop
cp yazi.desktop ~/.local/share/applications/
