#!/bin/zsh
basedir=$(cd `dirname $0`;pwd)
REPO='home:mazdlc:multilib-null'
for line in "$@"
do
    cd $basedir/../
    [ -d ${PREFIX}$line ] || osc meta pkg -e ${REPO} ${PREFIX}$line
    cd $basedir/../../
    osc co ${REPO}/${PREFIX}$line
    true
done

#osc up

for line in "$@"
do
    cd $basedir/../${PREFIX}$line || continue
    cp $basedir/PKGBUILD ./
    sed -i "s:PKGNAME:${line}:g" PKGBUILD
    osc add `ls`
    osc commit -m init
done