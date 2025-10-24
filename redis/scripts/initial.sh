#!/bin/bash
#sudo apt install redis-server

#sudo apt install redis-tools

#mkdir {7000...7005}

cat >/media/ssd2/redis/redis.conf <<EOF
port 7000
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000 
appendonly yes

# ------------------------------------ #
#            ACL Settings              #
# ------------------------------------ #

# If you choose to manage users in an external file (best practice),
# specify the path to the ACL file.
# The 'aclfile' directive will cause Redis to load and save ACL data
# from this file instead of redis.conf.
# This approach is best for managing ACLs dynamically.
aclfile /etc/redis/user.acl

# As an alternative, you can define ACLs directly in redis.conf,
# but this requires a restart to apply changes.
# For example, to define users directly in this file:
# user cluster-user on >clusterpassword +@all
# user your-app-user on >yourpassword +@allkeys allcommands


# ------------------------------------ #
#         Replication Settings         #
# ------------------------------------ #

# The user and password that replica nodes will use to authenticate
# with the primary node during replication.
# This should be your dedicated, high-privilege cluster user.
masteruser cluster-user
masterpass clusterpassword

# ------------------------------------ #
#         Additional Settings          #
# ------------------------------------ #

# Disable 'protected-mode' if you need to bind to all interfaces (for external access).
# Be sure to set ACLs or 'requirepass' if protected mode is off.
protected-mode no
bind 0.0.0.0
EOF