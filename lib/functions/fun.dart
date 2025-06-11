import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Color generateRandomColor() {
  final Random random = Random();
  final int r = random.nextInt(256);
  final int g = random.nextInt(256);
  final int b = random.nextInt(256);
  return Color.fromARGB(255, r, g, b);
}

Future<File?> getPhotoFromGallery(double ratioX, double ratioY) async {
  Future<File?> cropImage({required File imageFile}) async {
    CroppedFile? crop = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: CropAspectRatio(ratioX: ratioX, ratioY: ratioY));
    if (crop == null) return null;
    return File(crop.path);
  }

  final ImagePicker picker = ImagePicker();
  final image = await picker.pickImage(source: ImageSource.gallery);

  if (image == null) return null;

  File? img = File(image.path);
  img = await cropImage(imageFile: img);

  return img;
}

class UppercaseTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Convert the text to uppercase
    final uppercaseText = newValue.text.toUpperCase();

    return TextEditingValue(
      text: uppercaseText,
      selection: TextSelection.collapsed(offset: uppercaseText.length),
    );
  }
}

double nearestTen(double value) {
  return (value / 10).round() * 10.toDouble();
}

double roundToThousands(double value) {
  return (value * 1000).round() / 1000.0;
}
