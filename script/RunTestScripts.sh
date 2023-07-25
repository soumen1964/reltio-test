#!/bin/sh
for file in ./test/*.sh
do
	sh $file
  	res=$?
	if test "$res" != "0"; then
   		echo "Test script $file failed"
   		exit 1
	fi
done
