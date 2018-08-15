#!/usr/bin/env bash
# passing docker  enviroment variables
# ELASTICSEARCH_ENDPOINT
# ELASTICSEARCH_PORT
# 
source /etc/profile.d/java.sh
source /etc/profile.d/nutch.sh

envsubst < /opt/conf/nutch-site.xml.tmpl > $NUTCH_RUNTIME/conf/nutch-site.xml
envsubst < /opt/conf/nutch-site.xml.tmpl > $NUTCH_HOME/conf/nutch-site.xml

DATA=/opt/data
mkdir -p $DATA/crawldb $DATA/segments $DATA/linkdb $NUTCH_LOG_DIR
nutch inject $DATA/crawldb $DATA/urls
nutch generate $DATA/crawldb $DATA/segments
s1=$(ls -d $DATA/segments/2* | tail -1)
echo $s1
nutch fetch $s1
nutch parse $s1
nutch updatedb $DATA/crawldb $s1
nutch invertlinks $DATA/linkdb -dir $DATA/segments

nutch index  $DATA/crawldb/ -linkdb $DATA/linkdb/ $DATA/* -filter -normalize -deleteGone
