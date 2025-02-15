#!/bin/sh
#

FILES=$(ls $HOME/sh/*.sh)
for file in $FILES; do
  if [ -f $file ]; then
    chmod 755 $file
  fi
done
