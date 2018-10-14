#!/bin/bash

cd benchmark

for dirname in `ls -d */`; do
  cd $dirname
  make clean
  ../../run-clang-sa.sh
  cd ..
done
