#!/bin/bash
echo "Y" | hadoop namenode -format
$HADOOP_HOME/bin/start-all.sh
