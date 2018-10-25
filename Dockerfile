FROM ubuntu:16.04

# For Cleanup at End
WORKDIR /tmp

# Update apt
RUN apt-get update
RUN apt-get -yqq upgrade

# Install and configure network tools
RUN apt-get -yqq install ntp iputils-ping telnet dnsutils
RUN update-rc.d ntp defaults

# Install useful development tools
RUN apt-get -yqq install build-essential vim git wget bzip2 openssh-server

# Install JAVA
RUN apt-get -yqq install openjdk-8-jdk

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

RUN update-alternatives --install "/usr/bin/java" "java" "${JAVA_HOME}/bin/java" 1 && \
    update-alternatives --install "/usr/bin/javac" "javac" "${JAVA_HOME}/bin/javac" 1 && \
    update-alternatives --set java "${JAVA_HOME}/bin/java" && \
    update-alternatives --set javac "${JAVA_HOME}/bin/javac"

# Install Hadoop
ENV HADOOP_VERSION 2.9.1
RUN wget -q https://www.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
RUN tar -xzf hadoop-$HADOOP_VERSION.tar.gz -C /usr/local/
RUN mv /usr/local/hadoop-$HADOOP_VERSION /usr/local/hadoop
ENV HADOOP_HOME=/usr/local/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV YARN_CONF_DIR=$HADOOP_HOME/etc/hadoop

# Install Hive
ENV HIVE_VERSION 2.3.2
ENV HIVE_HOME=/usr/local/hive
RUN wget -q https://archive.apache.org/dist/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz
RUN tar -xzf apache-hive-$HIVE_VERSION-bin.tar.gz -C /usr/local/
RUN mv /usr/local/apache-hive-$HIVE_VERSION-bin /usr/local/hive
RUN wget -q https://jdbc.postgresql.org/download/postgresql-9.4.1212.jar -O $HIVE_HOME/lib/postgresql-jdbc.jar

# Add Hive and Hadoop home dir to PATH
ENV PATH=$PATH:$HIVE_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

# Cleanup
RUN rm -rf /tmp/*
RUN apt-get clean
WORKDIR /root
