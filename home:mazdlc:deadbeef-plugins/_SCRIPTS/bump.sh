#!/bin/sh
basedir=$(cd `dirname $0`;pwd)
REPO=home:mazdlc:deadbeef-plugins
cd $basedir/../

for vcs in git svn hg bzr
do
  ls | grep -P "\-${vcs}$" | while read line
  do
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
    NUM=$(rand 111 144)
    echo $NUM
    [[ $NUM == "116" ]] && bump $line
  done
done