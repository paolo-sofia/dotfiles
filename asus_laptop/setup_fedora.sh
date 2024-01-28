#!/bin/sh

#brave
#pycharm
#mpv
#obsidian
#nextcloud
#git
#xournal++
#spotify
#transmission
#jetbrains toolbox
#htop
#gparted
#forse jetbrains-mono-fonts
#mmex
#nemo file manager

# tlp o qualcosa di simile

# edit dnf conf
echo 'fastestmirror=1' | sudo tee -a /etc/dnf/dnf.conf
echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf
echo 'deltarpm=true' | sudo tee -a /etc/dnf/dnf.conf

# set hostname
hostnamectl set-hostname paolo

# install updates
sudo dnf upgrade --refresh -y
sudo dnf check -y
sudo dnf autoremove -y
sudo fwupdmgr get-devices
sudo fwupdmgr refresh --force -y
sudo fwupdmgr get-updates -y
sudo fwupdmgr update -y

mkdir "$HOME/git"
mkdir "$HOME/python-virtualenv"

# rpm fusion
dnf upgrade --refresh -y
dnf groupupdate core -y
sudo dnf install -y rpmfusion-free-release-tainted
sudo dnf install -y dnf-plugins-core
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# multimedia codecs
sudo dnf groupupdate sound-and-video -y
sudo dnf install -y libdvdcss
sudo dnf install -y gstreamer1-plugins-{bad-\*,good-\*,ugly-\*,base} gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel ffmpeg gstreamer-ffmpeg 
sudo dnf install -y lame\* --exclude=lame-devel
sudo dnf group upgrade --with-optional Multimedia -y

# install packages
sudo dnf install -y nextcloud-client git mpv foliate gparted htop transmission xournalpp kitty tldr nemo gnome-keyring okular nemo-image-converter nemo-gsconnect nextcloud-client-nemo folder-color-switcher-nemo gnome-text-editor bash-completion fzf pop-gnome-shell-theme.noarch pop-gtk4-theme pop-sound-theme pop-icon-theme gnome-tweaks gnome-shell-extension-appindicator pop-gnome-shell-theme pop-gtk4-theme pop-sound-theme pop-icon-theme stow

# brave
sudo dnf install dnf-plugins-core -y
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo dnf install brave-browser -y

sudo dnf remove totem gnome-font-viewer cheese-* baobab gnome-boxes gnome-connections gnome-user-docs libreoffice-* gnome-user-docs rhythmbox gnome-logs yelp gnome-characters gnome-font-viewer nautilus -y

# hyprland
#dnf copr enable solopasha/hyprland -y
#sudo dnf install -y hyprland

# flatpak e obsidian
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak update
flatpak install flathub md.obsidian.Obsidian -y
flatpak install flathub org.moneymanagerex.MMEX -y
flatpak install flathub com.mattjakeman.ExtensionManager -y
flatpak flatpak install flathub com.spotify.Client -y

# jetbrains toolbox e pycharm
brave-browser https://www.jetbrains.com/toolbox-app/download/download-thanks.html?platform=linux

# ruff
pip install ruff

# Install nerdfonts
wget https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip
mv JetBrainsMono-2.304.zip ~/.local/share/fonts
unzip -r ~/.local/share/fonts/JetBrainsMono-2.304.zip
rm ~/.local/share/fonts/JetBrainsMono-2.304.zip

# cloning git repo
cd ~/git || return
git clone https://github.com/AdnanHodzic/auto-cpufreq.git
git clone https://github.com/paolo-sofia/dotfiles.git
git clone https://github.com/paolo-sofia/background-setter.git
git clone https://github.com/paolo-sofia/amd-sfh-hid-dkms-asus.git

mkdir ~/.config/ruff

cd ~/git/dotfiles/.config || return
stow kitty -t /home/paolo/.config/kitty/
stow ruff -t /home/paolo/.config/ruff/
