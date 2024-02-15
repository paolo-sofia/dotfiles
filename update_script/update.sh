#!/bin/bash

cronjob="@reboot dnf update -y"
(sudo crontab -u root -l; echo "$cronjob" ) | sudo crontab -u root -


