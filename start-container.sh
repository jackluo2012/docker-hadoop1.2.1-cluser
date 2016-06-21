#!/bin/bash
# the default node number is 3
#sudo docker rm $(docker ps -a) &> /dev/null
N=${1:-3}
sudo docker stop hadoop-master > /dev/null 2>&1
sudo docker rm hadoop-master > /dev/null 2>&1
echo "start hadoop-master container..."
sudo docker run -td \
                --net=hadoop \
                -p 50070:50070 \
                -p 50030:50030 \
                --name hadoop-master \
                --hostname hadoop-master \
                jackluo/hadoop:1.2.1 > /dev/null

# start hadoop slave container
i=1
while [ $i -lt $N ]
do
	sudo docker stop hadoop-slave$i > /dev/null 2>&1
	sudo docker rm  hadoop-slave$i > /dev/null 2>&1
	echo "start hadoop-slave$i container..."
	sudo docker run -td \
	                --net=hadoop \
	                --name hadoop-slave$i \
	                --hostname hadoop-slave$i \
	                jackluo/hadoop:1.2.1 > /dev/null 2>&1
	i=$(( $i + 1 ))
done 

# get into hadoop master container
sudo docker exec -it hadoop-master start-hadoop.sh
