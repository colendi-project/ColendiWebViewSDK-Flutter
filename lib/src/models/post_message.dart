import '../enums/post_message_type.dart';
import '../enums/receiver_type.dart';
import '../utils/enum_factory.dart';

class PostMessage {
  final PostMessageType type;
  final ReceiverType receiverType;
  final String? message;

  const PostMessage({
    required this.type,
    this.receiverType = ReceiverType.web,
    this.message,
  });

  PostMessage copyWith({
    PostMessageType? type,
    ReceiverType? receiverType,
    String? message,
  }) {
    return PostMessage(
      type: type ?? this.type,
      receiverType: receiverType ?? this.receiverType,
      message: message ?? this.message,
    );
  }

  @override
  String toString() =>
      '''PostMessage(type: $type, receiverType: $receiverType, message: $message)''';

  factory PostMessage.fromJson(Map<String, dynamic> json) {
    return PostMessage(
      type: EnumFactory.postMessageTypeFromValue(json['type']),
      receiverType: EnumFactory.receiverTypeFromValue(json['receiverType']),
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'receiverType': receiverType.index,
      'message': message,
    };
  }

  String toJsonString() {
    return '''"{\\"type\\":\\"${type.name}\\", \\"receiverType\\":${receiverType.index}, \\"message\\":\\"$message\\"}"''';
  }
}
