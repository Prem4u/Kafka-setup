workdir="/media/ssd2/kafka"

if [ -f "$workdir/kafka_2.13-4.1.0.tgz" ]; then
    rm -f $workdir/kafka_2.13-4.1.0.tgz
fi

if [ -d "$workdir/kafka" ]; then
    rm -rf $workdir/kafka
fi

wget https://downloads.apache.org/kafka/4.1.0/kafka_2.13-4.1.0.tgz -O $workdir/kafka_2.13-4.1.0.tgz
tar -xzf $workdir/kafka_2.13-4.1.0.tgz -C $workdir
mv $workdir/kafka_2.13-4.1.0 $workdir/kafka