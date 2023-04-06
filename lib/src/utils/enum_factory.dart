import 'package:colendi_web_view_sdk_flutter/src/models/colendi_sdk_error.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

import '../enums/post_message_type.dart';
import '../enums/receiver_type.dart';

mixin EnumFactory {
  static PostMessageType postMessageTypeFromValue(String value) {
    return PostMessageType.values.firstWhere((e) => e.name == value);
  }

  static ReceiverType receiverTypeFromValue(int value) {
    return ReceiverType.values.firstWhere(
      (element) => element.index == value,
      orElse: () => ReceiverType.sdk,
    );
  }

  static FeedbackType feedbackTypeFromValue(String value) {
    return FeedbackType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw ColendiSdkError.invalidVibrationType,
    );
  }
}
