sudo nano /etc/logrotate.d/redis-hourly

# add the following content
/media/ssd2/redis/*/redis.log {
    hourly
    maxsize 100M
    rotate 0
    copytruncate
    missingok
    notifempty
    su prem prem
}
# set permissions
# logrotate will ignore any directories that are group-writable or world-writable.
# Ensure the redis directories are only writable by their owner.
sudo chmod 755 /media/ssd2/redis/*

# By default, logrotate runs daily via a systemd timer. 
# You need to override this timer to make it run every hour instead.

sudo systemctl edit logrotate.timer
# Add the following content to override the default timer
[Timer]
OnCalendar=
OnCalendar=hourly
AccuracySec=1m
# Save and exit the editor
# Reload systemd to apply the changes
sudo systemctl daemon-reload
# Restart the logrotate timer to apply the new schedule
sudo systemctl restart logrotate.timer
sudo systemctl enable logrotate.timer
# Check the status of the logrotate timer to ensure it's active and running hourly
sudo systemctl status logrotate.timer
# Test the logrotate configuration to ensure there are no syntax errors
sudo logrotate -d /etc/logrotate.d/redis-hourly
# To force log rotation and verify it works as expected, run:
sudo logrotate -f /etc/logrotate.d/redis-hourly
# Check the logrotate status file to see when the logs were last rotated
sudo cat /var/lib/logrotate/status

# Verify the timer is set to run hourly
sudo systemctl list-timers logrotate.timer