#!/bin/bash

mkdir -p '/root/.totalsegmentator'

if [ -e /root/.totalsegmentator/config.json ] ;
then
    line='"send_usage_stats": true'
    repl='"send_usage_stats": false'
    sed -i.bak "s/${line}/${repl}/g" '/root/.totalsegmentator/config.json'
else
    echo '{"send_usage_stats": true}' > '/root/.totalsegmentator/config.json'
fi