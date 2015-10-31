#!/bin/sh
basedir=$(cd `dirname $0`;pwd)
cd $basedir/../
ls */bump.sh | while read line
do
  zsh $line
done
