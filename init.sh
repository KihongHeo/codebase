#!/bin/bash

mkdir -p benchmark
cd benchmark

cat "../repos.txt" | while read r || [[ -n "$r" ]]; do
  dirname=`basename $r`
  dirname="${dirname%.*}"
  echo "Initializing $dirname"
  if [[ $r == \#* ]]; then
    continue
  elif [[ -d $dirname ]]; then
    cd $dirname
    echo "Pulling..."
    git pull > /dev/null
    cd ..
  else
    echo "Cloning..."
    git clone $r > /dev/null
  fi
done
