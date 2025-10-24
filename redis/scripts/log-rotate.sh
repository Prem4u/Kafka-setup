#!/bin/bash

while true; do
    if [ -f redis.log ] && [ $(stat -c%s redis.log) -gt $((100*1024*1024)) ]; then
        : > redis.log
    fi
    sleep 60
done
# Note: This script runs indefinitely. Consider running it in the background or as a systemd service.
