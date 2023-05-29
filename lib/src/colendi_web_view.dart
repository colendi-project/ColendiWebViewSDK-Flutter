import 'package:colendi_web_view_sdk_flutter/src/constants/constants.dart';
import 'package:colendi_web_view_sdk_flutter/src/enums/post_message_type.dart';
import 'package:colendi_web_view_sdk_flutter/src/enums/receiver_type.dart';
import 'package:colendi_web_view_sdk_flutter/src/enums/sdk_query_parameters.dart';
import 'package:colendi_web_view_sdk_flutter/src/models/colendi_sdk_error.dart';
import 'package:colendi_web_view_sdk_flutter/src/models/post_message.dart';
import 'package:colendi_web_view_sdk_flutter/src/utils/enum_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:colendi_web_view_sdk_flutter/src/extensions/uri_extension.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:locale_plus/locale_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ColendiWebView extends StatefulWidget {
  /// A Uri object representing the URL to load in the web view.
  final Uri url;

  /// A callback function that is called when
  /// a message is received from the web view.
  final void Function(String message)? messageCallback;

  /// A Color object representing the background
  /// color of the web view. The default value is Colors.white.
  final Color backgroundColor;

  /// A bool value indicating whether
  /// the web view should be displayed in full screen mode.
  /// The default value is false. When set to true,
  /// the web page can adjust its layout accordingly.
  final bool isFullScreen;

  /// A function that is called when a permission request is made in
  /// the Android version of the web view.
  /// It takes two arguments: the origin of the request, and a list of resources
  /// that are being requested.
  final Future<PermissionRequestResponse?> Function(
    String origin,
    List<String> resources,
  )? androidOnPermissionRequest;

  const ColendiWebView({
    required this.url,
    this.messageCallback,
    this.androidOnPermissionRequest,
    this.backgroundColor = Colors.white,
    this.isFullScreen = false,
    Key? key,
  }) : super(key: key);

  @override
  State<ColendiWebView> createState() => _ColendiWebViewState();
}

class _ColendiWebViewState extends State<ColendiWebView> {
  InAppWebViewController? _webViewController;

  Future<URLRequest> _setQueryParameters(Uri url) async {
    Uri uri = widget.url;

    uri = uri.appendQueryParameter(
      SdkQueryParameters.sdkVersion.name,
      Constants.sdkVersion,
    );

    final localePlus = LocalePlus();

    final secondsFromGMT = await localePlus.getSecondsFromGMT();
    if (secondsFromGMT != null) {
      uri = uri.appendQueryParameter(
        SdkQueryParameters.secondsFromGMT.name,
        secondsFromGMT.toString(),
      );
    }

    final regionCode = await localePlus.getRegionCode();
    if (regionCode != null) {
      uri = uri.appendQueryParameter(
        SdkQueryParameters.regionCode.name,
        regionCode,
      );
    }

    final languageCode = await localePlus.getLanguageCode();
    if (languageCode != null) {
      uri = uri.appendQueryParameter(
        SdkQueryParameters.languageCode.name,
        languageCode,
      );
    }

    final groupingSeperator = await localePlus.getGroupingSeparator();
    if (groupingSeperator != null) {
      uri = uri.appendQueryParameter(
        SdkQueryParameters.groupingSeperator.name,
        groupingSeperator,
      );
    }

    final decimalSeparator = await localePlus.getDecimalSeparator();
    if (decimalSeparator != null) {
      uri = uri.appendQueryParameter(
        SdkQueryParameters.decimalSeparator.name,
        decimalSeparator,
      );
    }

    final usesMetricSystem = await localePlus.usesMetricSystem();
    if (usesMetricSystem != null) {
      uri = uri.appendQueryParameter(
        SdkQueryParameters.usesMetricSystem.name,
        usesMetricSystem.toString(),
      );
    }

    if (widget.isFullScreen) {
      final topSafeArea = MediaQuery.of(context).padding.top;
      uri = uri.appendQueryParameter(
        SdkQueryParameters.topSafeArea.name,
        topSafeArea.toString(),
      );

      final bottomSafeArea = MediaQuery.of(context).padding.bottom;
      uri = uri.appendQueryParameter(
        SdkQueryParameters.bottomSafeArea.name,
        bottomSafeArea.toString(),
      );
    }

    return URLRequest(url: uri);
  }

  void _sendPostMessage(PostMessage message) {
    final js = Constants.jsSendMessage
        .replaceAll(Constants.jsonMessagePlaceholder, message.toJsonString());
    _webViewController?.evaluateJavascript(source: js);
  }

  void _messageHandler(PostMessage postMessage) {
    try {
      switch (postMessage.type) {
        case PostMessageType.client:
          if (postMessage.message == null) {
            throw ColendiSdkError.messageIsNull.name;
          } else {
            widget.messageCallback?.call(postMessage.message!);
          }
          break;
        case PostMessageType.initAmani:
          if (postMessage.message == null) {
            throw ColendiSdkError.messageIsNull.name;
          } else {
            // init amani
            throw ColendiSdkError.noAmaniFound.name;
          }
        case PostMessageType.vibrate:
          if (postMessage.message == null) {
            throw ColendiSdkError.messageIsNull.name;
          } else {
            final feedbackType =
                EnumFactory.feedbackTypeFromValue(postMessage.message!);
            Vibrate.feedback(feedbackType);
          }
          break;
        case PostMessageType.launchUrl:
          if (postMessage.message == null) {
            throw ColendiSdkError.messageIsNull.name;
          } else {
            final url = Uri.tryParse(postMessage.message!);
            if (url == null) {
              throw ColendiSdkError.invalidUrl.name;
            } else {
              launchUrl(url, mode: LaunchMode.externalApplication);
            }
          }
          break;
        case PostMessageType.copyToClipboard:
          Clipboard.setData(ClipboardData(text: postMessage.message ?? ''));
          break;
        default:
      }
    } catch (e) {
      final errorMessage =
          PostMessage(type: PostMessageType.error, message: '$e');
      _sendPostMessage(errorMessage);
    }
  }

  Future<void> _onWebViewCreated(InAppWebViewController controller) async {
    _webViewController = controller;

    final urlRequest = await _setQueryParameters(widget.url);
    await controller.loadUrl(urlRequest: urlRequest);

    const source = Constants.jsMessageListener;
    final userScript = UserScript(
      source: source,
      injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END,
      iosForMainFrameOnly: false,
    );

    controller.addUserScript(userScript: userScript);
    controller.addJavaScriptHandler(
      handlerName: Constants.jsListenerName,
      callback: (eventData) {
        try {
          final map = eventData[0] as Map<String, dynamic>;
          final message = PostMessage.fromJson(map);
          if (message.receiverType == ReceiverType.sdk) {
            _messageHandler(message);
          } else {
            return;
          }
        } catch (_) {
          return;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: widget.backgroundColor,
      child: InAppWebView(
        key: widget.key,
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            mediaPlaybackRequiresUserGesture: false,
            // javaScriptEnabled: true,
          ),
          android: AndroidInAppWebViewOptions(
            useHybridComposition: true,
          ),
          ios: IOSInAppWebViewOptions(
            allowsInlineMediaPlayback: true,
          ),
        ),
        androidOnPermissionRequest: (controller, origin, resources) async {
          return widget.androidOnPermissionRequest?.call(
            origin,
            resources,
          );
        },
        onWebViewCreated: _onWebViewCreated,
      ),
    );
  }
}
