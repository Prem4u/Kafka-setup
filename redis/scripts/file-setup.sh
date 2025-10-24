#!/usr/bin/env bash
set -euo pipefail
# Usage: ./update-redis-ports.sh [workspace-dir]
# Default workspace-dir: /home/cooltool/workspace


WORKDIR="${1:-/media/ssd2/redis}"
CONF_DIR="/home/prem/workspace/redis"
START=7000
END=7005

for d in $(seq "$START" "$END"); do
    dir="$WORKDIR/$d"
    mkdir -p "$dir"
    cp -- "$CONF_DIR/redis.conf" "$dir/redis.conf"
done
for d in $(seq "$START" "$END"); do
    
    dir="$WORKDIR/$d"
    file="$dir/redis.conf"

    if [ ! -f "$file" ]; then
        echo "Skipping: $file not found"
        continue
    fi

    echo "Updating $file -> port $d"

    # Keep an original backup once; additional runs create timestamped backups
    if [ ! -f "$file.orig" ]; then
        cp -- "$file" "$file.orig"
    else
        cp -- "$file" "$file.bak.$(date +%s)"
    fi

    # Replace a line like: port 7000  (preserves leading whitespace)
    sed -E -i "s/^([[:space:]]*port[[:space:]]+)7000\\b/\\1$d/" "$file"
done