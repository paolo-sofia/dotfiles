#!/bin/bash

sleep 10
# Check if this script is running
result=`ps aux | grep -i "tablet_mode_input_toggle.sh" | grep -v "grep" | wc -l`
if [ $result -gt 2 ]
   then
        echo "Script is already running"
        exit 0
   else
   	echo "Starting Script"
fi

# Configure these to match your hardware (names taken from `xinput` output).
TOUCHPAD="/dev/input/event8" # 'ASUE1201:00 04F3:3125 Touchpad'
KEYBOARD="/dev/input/event2" # 'AT Translated Set 2 keyboard'
# Clear sensor.log and acceldata.log so it doesn't get too long over time
> /tmp/sensor.log

# Launch monitor-sensor and store the output in a variable that can be parsed by the rest of the script
monitor-sensor >> /tmp/sensor.log 2>&1 &

PREVIOUS_ORIENTATION=
echo "monitor sensor"

# Parse output or monitor sensor to get the new orientation whenever the log file is updated
# Possibles are: normal, bottom-up, right-up, left-up
# Light data will be ignored
while inotifywait -e modify /tmp/sensor.log &> /dev/null; do
# Read the last line that was added to the file and get the orientation
ORIENTATION=$(tail -n 1 /tmp/sensor.log | grep 'orientation' | grep -oE '[^ ]+$')
echo $ORIENTATION

# Set the actions to be taken for each possible orientation
#if [ -z "$PREVIOUS_ORIENTATION" ]; then
#	PREVIOUS_ORIENTATION=$ORIENTATION
#	echo "initial orientation "
#fi


if [[ $PREVIOUS_ORIENTATION == "normal" && $ORIENTATION == "bottom-up" ]] || [[ -z "$PREVIOUS_ORIENTATION" && $ORIENTATION == "bottom-up"  ]]; then
	PREVIOUS_ORIENTATION=$ORIENTATION
	# Disable the keyboard	
	evtest --grab $TOUCHPAD > /dev/null &
	echo $ORIENTATION
	# Store the PID of the evtest process
	TOUCHPAD_PID=$!
	
	evtest --grab $KEYBOARD > /dev/null &
	# Store the PID of the evtest process
	KEYBOARD_PID=$!
else
	if [[ $PREVIOUS_ORIENTATION == "bottom-up" && $ORIENTATION == "normal" ]]; then
		# Re-enable the touchpad
		kill -9 $TOUCHPAD_PID
		wait $TOUCHPAD_PID
		echo $ORIENTATION

		kill -9 $KEYBOARD_PID
		wait $KEYBOARD_PID
		PREVIOUS_ORIENTATION=$ORIENTATION
	fi
fi

done 
