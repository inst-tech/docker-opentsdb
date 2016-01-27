FROM nimmis/java-centos:openjdk-8-jdk

MAINTAINER Jonathan Creasy <jonathan.creasy@gmail.com>

ENV JAVA_HOME /usr/lib/jvm/java
ENV OPENTSDB_VERSION=2.3.0-SNAPSHOT
ENV HBASE_VERSION 1.1.2
ENV HBASE_DATA /hbase-data
ENV HBASE_URL https://www.apache.org/dist/hbase/stable/hbase-$HBASE_VERSION-bin.tar.gz
ENV PATH $PATH:/usr/local/hbase/bin
ENV HBASE_ROOT_LOGGER WARN,console
ENV HBASE_SECURITY_LOGGER WARN,console

RUN curl $HBASE_URL | tar --directory /usr/local -xzf -
RUN ln -s /usr/local/hbase-$HBASE_VERSION /usr/local/hbase

## create the data folder
RUN mkdir $HBASE_DATA
RUN mkdir /etc/supervisor.d
RUN mkdir /usr/local/opentsdb
RUN mkdir /usr/local/opentsdb/staticroot
RUN mkdir /usr/local/opentsdb/etc
RUN mkdir /usr/local/opentsdb/cache
RUN mkdir /usr/local/opentsdb/lib

RUN yum -y install python-setuptools
RUN easy_install supervisor

ADD hbase/conf /usr/local/hbase/conf
ADD supervisor/supervisord-hbase.conf /etc/supervisor.d/hbase.conf
ADD supervisor/supervisord-opentsdb.conf /etc/supervisor.d/opentsdb.conf
ADD supervisor/supervisord.conf /etc/supervisord.conf
ADD opentsdb/staticroot /usr/local/opentsdb/staticroot
ADD opentsdb/etc /usr/local/opentsdb/etc
ADD opentsdb/lib /usr/local/opentsdb/lib
ADD opentsdb/bin /usr/local/opentsdb/bin

#RUN sed -i.bak -r 's/=(INFO|DEBUG)/=WARN/' /usr/local/hbase/conf/log4j.properties

VOLUME $HBASE_DATA

# zookeeper
EXPOSE 2181
# HBase Master API port
EXPOSE 60000
# HBase Master Web UI
EXPOSE 60010
# Regionserver API port
EXPOSE 60020
# HBase Regionserver web UI
EXPOSE 60030
# OpenTSDB Port
EXPOSE 4242

#USER root

CMD ["supervisord", "-n", "-c", "/etc/supervisord.conf"]
