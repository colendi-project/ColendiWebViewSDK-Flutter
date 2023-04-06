import 'package:colendi_web_view_sdk_flutter/colendi_web_view_sdk_flutter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      ),
    );
  }
}
