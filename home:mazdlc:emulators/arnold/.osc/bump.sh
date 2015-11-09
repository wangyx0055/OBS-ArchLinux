#!/bin/sh
basedir=$(cd `dirname $0`;pwd)
REPO=home:mazdlc
cd $basedir/../

function rand(){
    min=$1
    max=$(($2-$min+1))
    num=$(cat /dev/urandom | head -n 10 | cksum | awk -F ' ' '{print $1}')
    echo $(($num%$max+$min))
}

function bump(){
      #osc api -m POST "source/$REPO/$1?cmd=runservice"
      osc service remoterun $REPO $1
      osc rebuildpac $REPO/$1
}

NUM=$(rand 111 555)
echo $NUM
[[ $NUM == "116" ]] && bump arnold
