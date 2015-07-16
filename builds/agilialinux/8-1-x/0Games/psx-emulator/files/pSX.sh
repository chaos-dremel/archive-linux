#!/bin/sh

if [ ! -f $HOME/.pSX ]; then 
	mkdir -p $HOME/.pSX/bios
fi
cd $HOME/.pSX

pSX $@

exit $?
