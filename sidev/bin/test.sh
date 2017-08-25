#!/bin/bash

tarfiles="distribution/target/apache-drill*.tar.gz"
if ! ls $tarfiles > /dev/null 2>&1; then
   echo "No tarball to deploy! You are not in root directory of Drill source code or build failed."
   exit 1
fi
echo "Tarball found if we come to here"
