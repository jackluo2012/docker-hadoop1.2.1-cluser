#From index.alauda.cn/library/java:6
#FROM jackluo/ubuntu:14.04
FROM index.alauda.cn/library/ubuntu:14.04
# install openssh-server, openjdk and wget
RUN apt-get update && apt-get install -y openssh-server openjdk-7-jdk wget

RUN mkdir -p /opt/modules
RUN mkdir -p /opt/data/tmp
RUN mkdir -p /home/hadoop/

ADD hadoop-1.2.1.tar.gz /opt/modules/
ENV JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
ENV HADOOP_HOME /opt/modules/hadoop-1.2.1
WORKDIR /opt/modules/hadoop-1.2.1

ENV PATH $PATH:/opt/modules/hadoop-1.2.1/bin:$HADOOP_HOME

# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

COPY conf/* ./conf/

RUN mv ./conf/ssh_config ~/.ssh/config 
RUN mv ./conf/start-hadoop.sh ./bin/
RUN chmod a+x ./bin/start-hadoop.sh
# Volumes
#VOLUME /var/multrix

# Expose ports
EXPOSE 50070
EXPOSE 50030


# format namenode
#RUN hadoop namenode -format

CMD [ "sh", "-c", "service ssh start; bash"]
