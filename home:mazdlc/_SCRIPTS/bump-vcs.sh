#!/bin/sh
basedir=$(cd `dirname $0`;pwd)
REPO=home:mazdlc
cd $basedir/../

for vcs in git svn hg bzr
do
  ls | grep -v utvideo | grep -P "\-${vcs}$" | while read line
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
    
    
    case $line in
    fceux-svn)  #these packages are barely updated
      NUM=$(rand 111 999)
      echo $NUM
      [[ $NUM == "116" ]] && bump $line
    ;;
    mitsuba-hg|ardour-git|qsanguoshav2-git) 
    #these packages takes too long to build
      NUM=$(rand 111 300)
      echo $NUM
      [[ $NUM == "116" ]] && bump $line
    ;;
    wireshark-git|mkvtoolnix-git|edb-debugger-git|gimp-painter-git|amule-dlp-git) 
    #these packages takes long to build
      NUM=$(rand 111 255)
      echo $NUM
      [[ $NUM == "116" ]] && bump $line
    ;;
    *) #other packages are updated frequently
      NUM=$(rand 111 155)
      echo $NUM
      [[ $NUM == "116" ]] && bump $line
    ;;
    esac
    
    
  done
done