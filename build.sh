#/bin/bash

# Preparation exports
export PREFIX="$HOME/opt/cross"
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"]

make clean all
make all

