#!/bin/bash

handle_autoreconf() {
  autoreconf -vif >& autoreconf.log \
    || { echo "Error in autoreconf: see $PWD/autoreconf.log"; return 1; }
}

handle_autogen() {
  ./autogen.sh >& autogen.log \
    || { echo "Error in autogen.sh: see $PWD/autogen.log"; return 1; }
}

handle_configure() {
  ./configure >& config.log \
    || { echo "Error in configure: see $PWD/configure.log"; return 1; }
}

handle_cmake() {
  mkdir -p build
  cd build
  cmake .. >& cmake.log \
    || { echo "Error in cmake: see $PWD/cmake.log"; cd ..; return 1; }
  cd ..
}

cd benchmark

for dirname in `ls -d */`; do
  echo $dirname
  cd $dirname
  if [[ -f "Makefile" ]]; then
    echo "Skip"
  elif [[ -f "configure" ]]; then
    handle_configure
  elif [[ -f "CMakeLists.txt" ]]; then
    handle_cmake
  elif [[ -f "autogen.sh" ]]; then
    handle_autogen
    handle_configure
  elif [[ -f "bootstrap" ]]; then
    ./bootstrap
    handle_configure
  elif [[ -f "buildconf" ]]; then
    ./buildconf
    handle_configure
  elif [[ -f "configure.ac" ]]; then
    handle_autoreconf
    handle_configure
  else
    echo "Not found"
  fi
  cd ..
done
