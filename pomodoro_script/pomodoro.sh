#!/bin/bash

pids=$(pgrep -f script.sh)
num_pids=$(echo "$pids" | wc -w)
echo "$num_pids"

# shellcheck disable=SC2086
if [ $num_pids -eq 2 ]; then
    echo "script already running"
    exit
elif [ $num_pids -gt 2 ]; then 
    echo "more than one script running, killing the others and keeping the first"
    pid_array=()
    for pid in $pids; do
        pid_array+=("$pid")
    done

   # Iterate through the array starting from the second element
    for ((i = 1; i < ${#pid_array[@]}; i++)); do
        pid=${pid_array[$i]}
        echo "Killing PID $pid"
        kill "$pid"
    done
    exit
else
    echo "starting script"
fi

DEFAULTVALUE=false
notify_enabled="${1:-$DEFAULTVALUE}"
notification_sound=/usr/share/sounds/Pop/stereo/notification/message-new-instant.oga

if [ "$notify_enabled" = 'true' ]; then
    notify-send 'Timer partito' 'Pausa tra 20 minuti' -t 5000
fi

if command -v paplay &> /dev/null
then
    audio_player=paplay
else
    if command -v pw-play &> /dev/null
    then
        audio_player=pw-play
    fi
fi
$audio_player $notification_sound 

while true
do
  sleep 20m
  value=$(gsettings get org.gnome.desktop.notifications show-banners)

  # shellcheck disable=SC2086
  if [ $notify_enabled = 'true' ]; then
    notify-send 'Pausa!' 'Pausa di 20 secondi' -t 5000
  fi

  if [ "$value" = 'true' ]; then
    $audio_player $notification_sound
    sleep 20
    value=$(gsettings get org.gnome.desktop.notifications show-banners)
    if [ "$value" = 'true' ]; then
        $audio_player $notification_sound
	if [ "$notify_enabled" = 'true' ]; then
            notify-send 'Pausa finita!' 'Prossima pausa tra 20 minuti' -t 5000
      fi
    else
      sleep 60
    fi
  else
    sleep 60
  fi
  
done



