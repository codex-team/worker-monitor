#!/bin/bash

# Get number of workers that should be running (assuming the number is being passed as the parameter to the script)
qty=$1

# Check number of connections to rabbitmq
connections=$(rabbitmqctl list_connections | tail -n +1)
working=$(echo $connections | wc -l)

# Compare with overally number of workers
# If some workers are not connected, send notification
if [[ $qty>$working ]]; then
	curl -X POST https://notify.bot.ifmo.su/u/ABCD1234 -d "Some workers have died! A necromancer is needed!"
fi
