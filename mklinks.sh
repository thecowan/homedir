#!/bin/bash

BASEPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HOMEDIR=$HOME/
RELPATH=${BASEPATH##$HOMEDIR}/

echo "Checking symlinks in $HOME relative to $RELPATH..."

cd $BASEPATH
files=.*

for file in $files; do
  case $file in
  . | .. )
    ;;
  README | mklinks.sh | .git )
    ;;
  .ssh )
    echo "IGNORING $file - not ready to handle non-complete dirs!" ;; 
  * )
    cd $HOMEDIR
    target=$RELPATH$file
    echo -n " Checking $file for link to $target... "
    if [ -h $file ]; then
      existing=$(readlink $file)
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
