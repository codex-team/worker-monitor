# worker-monitor
Watching you, robot

Monitoring RabbitMQ workers.

Usage: monitor.sh [-h] -w <number of workers> -i <chat id>
where:
    -h  show help message
    -w  overall number of workers
    -i  id of a chat where to send alerts

Install into your crontab file:

```shell
<time interval in cron format> monitor.sh -w <number of workers> -i <chat id>
```
