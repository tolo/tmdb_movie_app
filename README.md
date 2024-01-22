# Flutter Movies app with Result Notifier (TMDB API)

This is a fork of [TMDB Movies by Andrea Bizzotto](https://github.com/bizz84/tmdb_movie_app_riverpod), refactored to use the 
[ResultNotifier](https://pub.dev/packages/result_notifier) package instead of Riverpod.



## Packages in use

- [ResultNotifier](https://pub.dev/packages/result_notifier) for data caching (and much more!)
- [json_serializable](https://pub.dev/packages/json_serializable) for JSON serialization
- [dio](https://pub.dev/packages/dio) for networking
- [go_router](https://pub.dev/packages/go_router) for navigation
- [shimmer](https://pub.dev/packages/shimmer) for the loading UI
- [envied](https://pub.dev/packages/envied) for handling API keys
- [cached_network_image](https://pub.dev/packages/cached_network_image) for caching images


## Getting a TMDB API key

This project uses the TMDB API to get the latest movies data.

Before running the app you need to [sign up on the TMDB website](https://www.themoviedb.org/signup), then obtain an API key on the [settings API page](https://www.themoviedb.org/settings/api).

Once you have this, create an `.env` file **at the root of the project** and add your key:

```dart
// .env
TMDB_KEY=your-api-key
```

Then, run the code generator:

```
dart run build_runner build --delete-conflicting-outputs
```

This will generate a `env.g.dart` file inside `lib/env`. This contains the `tmdbApiKey` that is used when making requests to the TMDB API.

Congratulations, you're good to go. 😎

## Note: Loading images from insecure HTTP endpoints

The data returned by the TMBD API points to image URLs using http rather than https. In order for images to load correctly, the following changes have been made:

### Android

Created a file at `android/app/src/main/res/xml/network_security_config.xml` with these contents:

```
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <base-config cleartextTrafficPermitted="true" />
</network-security-config>
```

Added this to the application tag in the `AndroidManifest.xml`:

```
android:networkSecurityConfig="@xml/network_security_config"
```

### iOS

Add the following to `ios/Runner/info.pList`:

```
  <key>NSAppTransportSecurity</key>
  <dict>
      <key>NSAllowsArbitraryLoads</key>
      <true/>
  </dict>
```

More information here:

- [Insecure HTTP connections are disabled by default on iOS and Android.](https://flutter.dev/docs/release/breaking-changes/network-policy-ios-android)

### macOS

Since macOS applications are sandboxed by default, we get a `SocketException` if we haven't added the required entitlements. This has been fixes by adding these lines to `macos/Runner/DebugProfile.entitlements` and `macos/Runner/Release.entitlements`:

```
<key>com.apple.security.network.client</key>
<true/>
```

More info here:

- [How to fix "SocketException: Connection failed (Operation not permitted)" with Flutter on macOS](https://codewithandrea.com/tips/socket-exception-connection-failed-macos/)

## [LICENSE: MIT](LICENSE.md)
