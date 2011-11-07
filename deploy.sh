#! /bin/sh

git add .
echo "Added files to git"
git commit -m "fast commit"
echo "Committed to git"
git push
echo "pushing to remote repo"
RUBBER_ENV=production cap deploy:fast
echo "DEPLOYED.  YAY!"