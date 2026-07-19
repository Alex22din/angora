#!/bin/bash
set -e

echo "Building Flutter Web app with base-href /angora/..."
flutter build web --base-href "/angora/"

echo "Deploying build/web to gh-pages branch..."
cd build/web

# Check if git is already initialized in build/web
if [ ! -d ".git" ]; then
    git init
    git checkout -b gh-pages
    git remote add origin git@github.com:Alex22din/angora.git
else
    # Make sure we are on gh-pages branch
    git checkout -B gh-pages
fi

git add .
git commit -m "Deploy to GitHub Pages"
git push -f origin gh-pages

echo "Successfully deployed!"
