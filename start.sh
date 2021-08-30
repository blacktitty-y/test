#!/bin/bash
if [ ! -f config/am.sh ]
then
cp am.sh config
fi
if [ ! -f config/config.yaml ]
then
cp clash/config.yaml config
fi
nohup clash/clash -d config &
export http_proxy=http://127.0.0.1:7890
export https_proxy=http://127.0.0.1:7890
./config/am.sh
/bin/bash
