#!/bin/bash

WORKDIR=.
if [ $# -gt 1 ]; then
   WORKDIR=$1
fi

find $WORKDIR -name "*.jar" | while read p
do
   unzip -l $p
done

