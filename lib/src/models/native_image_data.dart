import 'dart:convert';
import 'dart:typed_data';

class NativeImageData {
  final String imageUrl;
  final Uint8List imageBytes;

  const NativeImageData({required this.imageUrl, required this.imageBytes});

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'imageBytes': imageBytes,
    };
  }

  String toEncodedString() {
    return jsonEncode(toMap());
  }
}
