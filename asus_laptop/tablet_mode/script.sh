#!/usr/bin/sh

chown root:root tablet_mode_input_toggle.sh
chmod 744 tablet_mode_input_toggle.sh

ln -s $(pwd)/tablet_mode_input_toggle.sh /usr/local/bin/
ln -s $(pwd)/tablet_mode.service /etc/systemd/system/

