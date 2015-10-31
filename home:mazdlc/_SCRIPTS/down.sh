#!/bin/sh
basedir=$(cd `dirname $0`;pwd)
REPO=home:mazdlc
ARCH=Arch_Extra
cd $basedir/../

ps -ef | grep down.sh | grep -v grep || exit 0

nstatus=`curl -s "https://build.opensuse.org/project/monitor/${REPO}?arch_x86_64=1&defaults=0&repo_${ARCH}=1&scheduled=1"|grep -oP "(?<=status'>)scheduled"|head -1`
[[ z$nstatus == z ]] && exit 0


for vcs in git svn hg bzr
do
  ls | grep -P "\-${vcs}$" | while read line
  do
    cd $basedir/../$line
    echo Package $line
    [[ z`osc results|grep broken` == z ]] || osc service remoterun $REPO $line
    [[ z`osc results|grep scheduled` == z ]] && echo skip || osc service remoterun $REPO $line
  done
done