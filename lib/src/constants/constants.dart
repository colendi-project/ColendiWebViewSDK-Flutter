mixin Constants {
  static const sdkVersion = '1.3.0';

  static const jsMessageListener = '''
              window.addEventListener("message", function(event) {
                 window.flutter_inappwebview.callHandler('$jsListenerName', event.data);
              });
         ''';
  static const jsSendMessage = 'window.postMessage($jsonMessagePlaceholder)';
  static const jsListenerName = 'nativeListener';
  static const jsonMessagePlaceholder = 'JSON_MESSAGE_PLACEHOLDER';
}
