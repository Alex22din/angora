#!/bin/bash
set -e

echo "Building Flutter Web app..."
flutter build web --base-href "/"

SHORT_SHA="$(git rev-parse --short HEAD)"
sed -i "s/__APP_VERSION__/${SHORT_SHA}/g" build/web/index.html

echo "Deploying to Firebase Hosting..."
firebase deploy --only hosting:anguracafeteriaandrestaurant

echo "Successfully deployed!"
