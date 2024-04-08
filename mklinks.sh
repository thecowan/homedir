#!/bin/bash

function loginfo() {
  if [ -z "$errors_only" ]; then
    echo "$1"
  fi
}
function logerror() {
  echo "$1"
  ret=1
}

function linkdir() {
  local base=$1
  local rel=$2
  local relprefix=$3
  local home=$4
  local pad=$5
  local fullbase=$base$rel
  local relpath=${fullbase##$home/}
  local relhome=$home$rel

  cd $home
  loginfo "${pad}Checking symlinks in $relhome relative to $relpath..."
  if [ ! -d $relhome ]; then
    loginfo "${pad} $relhome doesn't exist, $creating"
    mkdir $relhome
  fi

  cd $fullbase
  local files=*

  for file in $files; do
    case $file in
    . | .. )
      ;;
    README | mklinks.sh | .git | .nolink | .gitignore )
      ;;
    * )
      cd $relhome
      local target=$relprefix$relpath$file
      pre="${pad}Checking $file for link to $target..."
      if [ -d $target -a -f $target/.nolink ]; then
        loginfo "$pre directory with .nolink, recursing."
        linkdir $base $rel$file/ "../$relprefix" $home "$pad  "
        cd $relhome
      elif [ -h $file ]; then
        local existing=$(readlink $file)
        if [ "$existing" == "$target" ]; then
          loginfo "$pre OK (already existing)"
        else
          logerror "$pre ERROR: already links to $existing"
        fi 
      elif [ -e $file ]; then
        logerror "$pre ERROR: already exists" 
      else
        logerror "$pre$creating"
	if [ -z "$dryrun" ]; then
          ln -s $target $file
	fi
      fi
    esac
  done
}
dryrun=''
creating='creating'
errors_only=''
ret=0
while getopts 'en' flag; do
  case "${flag}" in
    e) errors_only='true' ;;
    n) dryrun='true' creating='not creating (DRY-RUN)' ;;
  esac
done

BASEPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
shopt -s dotglob


linkdir $BASEPATH / "" $HOME ""

chmod 700 ~/.ssh/control
exit $ret

