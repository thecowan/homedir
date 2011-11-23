#!/bin/bash

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
  echo "${pad}Checking symlinks in $relhome relative to $relpath..."
  if [ ! -d $relhome ]; then
    echo "${pad} $relhome doesn't exist, creating"
    mkdir $relhome
  fi

  cd $fullbase
  local files=*

  for file in $files; do
    case $file in
    . | .. )
      ;;
    README | mklinks.sh | .git | .nolink )
      ;;
    * )
      cd $relhome
      local target=$relprefix$relpath$file
      echo -n "${pad}Checking $file for link to $target... "
      if [ -d $target -a -f $target/.nolink ]; then
        echo 'directory with .nolink, recursing.'
        linkdir $base $rel$file/ "../$relprefix" $home "$pad  "
        cd $relhome
      elif [ -h $file ]; then
        local existing=$(readlink $file)
        if [ "$existing" == "$target" ]; then
          echo "OK (already existing)"
        else
          echo "ERROR: already links to $existing"
        fi 
      elif [ -e $file ]; then
        echo "ERROR: already exists" 
      else
        echo "CREATING"
        ln -s $target $file
      fi
    esac
  done
}

BASEPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
shopt -s dotglob

linkdir $BASEPATH / "" $HOME ""


