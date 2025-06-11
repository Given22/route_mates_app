# route_mates

To run app, need to be add .env with the following variables:
- MAPBOX_ACCESS_TOKEN


To build app for Google Play:
1. Get keystore file from admin

2. In android folder, create file key.properties:
```
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=<keystore-file-location>
```
3. Setup properly versionCode at app/build.gradle file

4. Build an app bundle
```
flutter build appbundle
```

Emulators:
- setup firebase
- firebase emulators:start  --import=./emu_data --export-on-exit emu_data