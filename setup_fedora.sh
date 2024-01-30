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

gitclone()
{
  URL=$2
  FOLDER=$1
  if [ ! -d "$FOLDER" ] ; then
      git clone "$URL" "$FOLDER"
  fi
}
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

mkdir -p "$HOME/git"
mkdir -p "$HOME/python-virtualenv"

# rpm fusion
sudo dnf upgrade --refresh -y
sudo dnf groupupdate core -y
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
sudo dnf install -y python3-pip ruff nextcloud-client git mpv foliate gparted htop transmission xournalpp kitty tldr nemo gnome-keyring okular nemo-image-converter nemo-gsconnect nextcloud-client-nemo folder-color-switcher-nemo gnome-text-editor bash-completion fzf pop-gnome-shell-theme.noarch pop-gtk4-theme pop-sound-theme pop-icon-theme gnome-tweaks gnome-shell-extension-appindicator pop-gnome-shell-theme pop-gtk4-theme pop-sound-theme pop-icon-theme stow poetry seahorse

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
flatpak install flathub com.spotify.Client -y

# jetbrains toolbox e pycharm
brave-browser https://www.jetbrains.com/toolbox-app/download/download-thanks.html?platform=linux

# update pip
pip install --upgrade pip

# Install nerdfonts
wget https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip
mv JetBrainsMono-2.304.zip ~/.local/share/fonts
unzip -r ~/.local/share/fonts/JetBrainsMono-2.304.zip
rm ~/.local/share/fonts/JetBrainsMono-2.304.zip

# cloning git repo
cd ~/git || return

gitclone auto-cpufreq https://github.com/AdnanHodzic/auto-cpufreq.git
gitclone dotfiles https://github.com/paolo-sofia/dotfiles.git
gitclone background-setter https://github.com/paolo-sofia/background-setter.git
gitclone amd-sfh-hid-dkms-asus https://github.com/paolo-sofia/amd-sfh-hid-dkms-asus.git

## Add dotfiles
mkdir -p ~/.config/ruff
cd ~/git/dotfiles || return
stow -R bash -t ~/
stow -R git -t ~/
stow -R input -t ~/
stow -R kitty -t /home/paolo/.config/kitty/
stow -R nano -t ~/
stow -R ruff -t /home/paolo/.config/ruff/

## Create new ssh key and add to github
ssh-keygen -t ed25519 -a 128 -f ~/.ssh/id_ed25519
ssh-add

brave-browser https://github.com/settings/keys

## setting up pomodoro script and background setter
cp pomodoro_script/Script.desktop ~/.config/autostart/


python -m venv ~/python-virtualenv/background-setter-venv/venv/
source ~/python-virtualenv/background-setter-venv/venv/bin/activate
pip install --upgrade pip
pip install -r ~/git/background-setter/requirements.txt
deactivate

cp ~/git/background-setter/Sfondi.desktop ~/.config/autostart/

