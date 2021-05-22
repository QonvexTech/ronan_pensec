name: Build & Deploy Website
on:
push:
branches:
- master
jobs:
hosting:
name: Deploy Website
runs-on: ubuntu-latest
steps:
# Checkout Repository
- uses: actions/checkout@v1

# Install Flutter command
- uses: subosito/flutter-action@v1
with:
channel: 'stable'

# Build Website
- name: Build Website
run: |
flutter upgrade
flutter config --enable-web
flutter pub get
flutter build web --release --web-renderer html
working-directory: ./

# Deploy Firebase Hosting
- name: Deploy Firebase Hosting
uses: w9jds/firebase-action@master
with:
args: deploy --only hosting:obrero
env:
FIREBASE_TOKEN: ${{ secrets.FIREBASE_TOKEN }}
PROJECT_PATH: ./