#!/bin/bash

# Help message
usage="$(basename "$0") [-h] -w <number> -i <chat id> -- script to monitor RabbitMQ workers
where:
    -h  show this help text
    -w  overall number of workers
    -i  id of a chat where to send alerts"

if [ $# -lt 1 ]
then
	echo "No options found."
	echo "Usage: $usage"
	exit 1
fi

# Check options
while getopts ':w:a:h' option; do
  case "$option" in
	h) echo "$usage" 						# help message
	   exit
	   ;;
	w) if [[ $OPTARG =~ ^-[i/w]$ ]]; then				# check if -w has args
	   	echo "Unknow argument $OPTARG for option $opt"
		echo "Usage: $usage"
		exit 1
	   fi
	   qty=$OPTARG
           ;;
	i) if [[ $OPTARG =~ ^-[i/w]$ ]]; then				# check if -i has args
                echo "Unknow argument $OPTARG for option $opt"
                echo "Usage: $usage"
                exit 1
           fi
           chat=$OPTARG
           ;;
	:) printf "missing argument for -%s\n" "$OPTARG" >&2		# check if arg is missing
           echo "Usahe: $usage" >&2
           exit 1
           ;;
	*) printf "illegal option: -%s\n" "$OPTARG" >&2			# check if options are -h/-w/-a
           echo "Usage: $usage" >&2
           exit 1
           ;;
  esac
done
shift $((OPTIND - 1))

# Check number of connections to rabbitmq
working=$(rabbitmqctl list_connections | tail -n +2 | wc -l)

# Compare with overally number of workers
# If some workers are not connected, send notification
if (( $qty>$working )); then
	echo "curl -X POST https://notify.bot.ifmo.su/u/$chat -d Some workers have died! A necromancer is needed!"
fi
