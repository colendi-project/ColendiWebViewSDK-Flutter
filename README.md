# ColendiWebViewSDK-Flutter

The Colendi Web View Software Development Kit.

# Table of Content
- [Overview](#overview)
- [Requirements](#requirements)
- [Installation](#installation)
- [Integration](#integration)
- [Author](#author)
- [LICENSE](#license)

# Overview

The Colendi Web View is a Software Development Kit developed by Colendians to enable fast and simple integration to Colendi World.

# Requirements

- Dart: ">=3.1.0 <4.0.0"
- Flutter: ">=3.13.0"
- Android: minSdkVersion 19
- iOS 11.0+

# Installation

with Flutter: 

```
$ flutter pub add colendi_web_view_sdk_flutter
```

This will add a line like this to your package's pubspec.yaml (and run an implicit `flutter pub get`):

```
dependencies:
  colendi_web_view_sdk_flutter: ^1.5.0
```

# Integration

```dart
class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ColendiWebView(
        /// Set url to open ColendiWebView
        url: Uri.parse('URL_STRING'),

        /// Set isFullScreen false before loadUrl function to open ColendiWebView fullscreen.
        isFullScreen: true,

        /// Handle message from ColendiWebView
        messageCallback: (message) {
          debugPrint(message);
        },

        /// Send message to ColendiWebView
        onServiceCreated: (instance) {
          instance.sendMessage('message to ColendiWebView');
        },
      ),
    );
  }
}

```

# Author

[Colendi](https://www.twitter.com/colendiapp)

# License

ColendiWebView is available under the GNU GENERAL PUBLIC LICENSE license. See the LICENSE file for more info.
