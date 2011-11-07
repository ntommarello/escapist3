#! /bin/sh

git add .
echo "Added files to git"
git commit -m $1
echo "Committed to git"
git push
echo "pushing to remote repo"
RUBBER_ENV=production cap deploy$2
echo "DEPLOYED.  YAY!"