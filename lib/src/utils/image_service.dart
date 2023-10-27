import 'dart:typed_data';

import 'package:http/http.dart' as http;

Future<Uint8List?> getImage(String imageUrl) async {
  try {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    }

    return null;
  } catch (_) {
    return null;
  }
}
