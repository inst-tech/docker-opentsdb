#!/usr/bin/env bash
eval "$(docker-machine env dev)"
docker build -t docker-opentsdb .; docker run --rm -it -p 60010:60010 -p 60020:60020 -p 60030:60030 -p 4242:4242 -v /hbase-data:$(pwd)/docker/hbase-data docker-opentsdb; docker rmi docker-opentsdb
