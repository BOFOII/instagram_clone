import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<Uint8List?> imagePicker(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  return null;
}

showSnackBar(Widget content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: content));
}
