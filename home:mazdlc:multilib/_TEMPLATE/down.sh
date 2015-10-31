#!/bin/sh
basedir=$(cd `dirname $0`;pwd)
REPO=home:mazdlc:multilib
ARCH=Arch_Extra
cd $basedir/../

ls|while read line
do
    cd $basedir/../$line
    echo Package $line
    [[ z`osc results|grep broken` == z ]] && echo skip || osc service remoterun $REPO $line
done
