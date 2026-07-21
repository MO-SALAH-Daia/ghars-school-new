import 'dart:convert';
import 'dart:io';

Future<String?> fileToBase64(File? file) async {
  if (file == null) {
    return null;
  }
  final bytes = await file.readAsBytes();
  return base64Encode(bytes);
}
