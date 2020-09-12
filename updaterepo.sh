#!/bin/bash

rm kramsg1_repo*


echo "repo-add"
repo-add -s -n -R kramsg1_repoo.db.tar.gz *.pkg.tar.xz
repo-add -s -n -R kramsg1_repo.db.tar.gz *.pkg.tar.zst
#sleep 8
cp -f kramsg1_repo.db.tar.gz kramsg1_repo.db

echo "####################################"
echo "Repo Updated!!"
echo "####################################"
