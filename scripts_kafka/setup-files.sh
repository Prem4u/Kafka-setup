#!/bin/bash


#==========================
#broker set up files
#==========================

IPADDR=$(hostname -I | awk '{print $1}')

workdir=/media/ssd2/kafka/kafka

# Define source and destination files
SRC="$workdir/config/broker.properties"
DEST="$workdir/config/broker-01.properties"

# Copy the original file
cp "$SRC" "$DEST"
# Replace node.id=2 with node.id=1 in the new file
sed -i 's/node\.id=2/node.id=1/g' "$DEST"


sed -i "s|advertised.listeners=PLAINTEXT://localhost:9092|advertised.listeners=PLAINTEXT://$IPADDR:9093|g" "$DEST"

sed -i 's|listeners=PLAINTEXT://localhost:9092|listeners=PLAINTEXT://0.0.0.0:9091|g' "$DEST"
echo "Copied $SRC to $DEST and replaced node.id=2 with node.id=1"
sed -i 's/^\(controller\.quorum\.bootstrap\.servers.*\)$/#\1/' "$DEST"
sed -i 's|log\.dirs=/tmp/kraft-broker-logs|log.dirs=/tmp/kraft-broker-logs-01|g' "$DEST"
echo "controller.quorum.voters=4@$IPADDR:9094,5@$IPADDR:9095,6@$IPADDR:9096" >> "$DEST"
echo "Added controller.quorum.voters to $DEST"
# Create broker-02.properties
DEST2="$workdir/config/broker-02.properties"
cp "$SRC" "$DEST2"
sed -i 's/node\.id=2/node.id=2/g' "$DEST2"
sed -i 's/^\(controller\.quorum\.bootstrap\.servers.*\)$/#\1/' "$DEST2"

sed -i "s|advertised.listeners=PLAINTEXT://localhost:9092|advertised.listeners=PLAINTEXT://$IPADDR:9093|g" "$DEST2"
sed -i 's|listeners=PLAINTEXT://localhost:9092|listeners=PLAINTEXT://0.0.0.0:9092|g' "$DEST2"
sed -i 's|log\.dirs=/tmp/kraft-broker-logs|log.dirs=/tmp/kraft-broker-logs-02|g' "$DEST2"
echo "controller.quorum.voters=4@$IPADDR:9094,5@$IPADDR:9095,6@$IPADDR:9096" >> "$DEST2"
echo "Created $DEST2 with node.id=2 and updated log.dirs"

# Create broker-03.properties
DEST3="$workdir/config/broker-03.properties"
cp "$SRC" "$DEST3"
sed -i 's/node\.id=2/node.id=3/g' "$DEST3"
sed -i 's/^\(controller\.quorum\.bootstrap\.servers.*\)$/#\1/' "$DEST3"

sed -i "s|advertised.listeners=PLAINTEXT://localhost:9092|advertised.listeners=PLAINTEXT://$IPADDR:9093|g" "$DEST3"
sed -i 's|listeners=PLAINTEXT://localhost:9092|listeners=PLAINTEXT://0.0.0.0:9093|g' "$DEST3"
sed -i 's|log\.dirs=/tmp/kraft-broker-logs|log.dirs=/tmp/kraft-broker-logs-03|g' "$DEST3"
echo "controller.quorum.voters=4@$IPADDR:9094,5@$IPADDR:9095,6@$IPADDR:9096" >> "$DEST3"
echo "Created $DEST3 with node.id=3 and updated log.dirs"

#==========================
#Controller set up files
#==========================

#create controller-04.properties
SRC="$workdir/config/controller.properties"
DEST="$workdir/config/controller_04.properties"
cp "$SRC" "$DEST"
sed -i 's/node\.id=1/node.id=4/g' "$DEST"
sed -i "s|advertised.listeners=CONTROLLER://localhost:9093|advertised.listeners=CONTROLLER://$IPADDR:9094|g" "$DEST"
sed -i 's/9093/9094/g' "$DEST"

sed -i 's|log\.dirs=/tmp/kraft-controller-logs|log.dirs=/tmp/kraft-controller-logs-04|g' "$DEST"
sed -i 's/^\(controller\.quorum\.bootstrap\.servers.*\)$/#\1/' "$DEST"
echo "controller.quorum.voters=4@$IPADDR:9094,5@$IPADDR:9095,6@$IPADDR:9096" >> "$DEST"
echo "Created $DEST with node.id=4 and updated log.dirs"

#Create controller-05.properties
DEST2="$workdir/config/controller_05.properties"
cp "$SRC" "$DEST2"
sed -i 's/node\.id=1/node.id=5/g' "$DEST2"
sed -i "s|advertised.listeners=CONTROLLER://localhost:9093|advertised.listeners=CONTROLLER://$IPADDR:9095|g" "$DEST2"
sed -i 's/9093/9095/g' "$DEST2"

sed -i 's|log\.dirs=/tmp/kraft-controller-logs|log.dirs=/tmp/kraft-controller-logs-05|g' "$DEST2"
sed -i 's/^\(controller\.quorum\.bootstrap\.servers.*\)$/#\1/' "$DEST2"
echo "controller.quorum.voters=4@$IPADDR:9094,5@$IPADDR:9095,6@$IPADDR:9096" >> "$DEST2"
echo "Created $DEST2 with node.id=5 and updated log.dirs"

# Create controller-06.properties

DEST3="$workdir/config/controller_06.properties"
cp "$SRC" "$DEST3"
sed -i 's/node\.id=1/node.id=6/g' "$DEST3"
sed -i "s|advertised.listeners=CONTROLLER://localhost:9093|advertised.listeners=CONTROLLER://$IPADDR:9096|g" "$DEST3"
sed -i 's/9093/9096/g' "$DEST3"
sed -i 's|log\.dirs=/tmp/kraft-controller-logs|log.dirs=/tmp/kraft-controller-logs-06|g' "$DEST3"

sed -i 's/^\(controller\.quorum\.bootstrap\.servers.*\)$/#\1/' "$DEST3"
echo "controller.quorum.voters=4@$IPADDR:9094,5@$IPADDR:9095,6@$IPADDR:9096" >> "$DEST3"
echo "Created $DEST3 with node.id=6 and updated log.dirs"