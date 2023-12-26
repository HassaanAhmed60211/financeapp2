import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ColorConstraint {
  Color? primaryColor = Color(0xffFDFDFD);
 static const secondaryColor = Color(0xff1F2C37);
  Color? backColor = Colors.blue[900];
  static const whiteColor = Colors.white;

  static const bgIconColor = Color(0xffDDECFF);
  static const primaryLightColor = Color(0xFF004AAD);
}

class ImagePickerUtil {
  static Future<List<XFile>> pickMultipleImages() async {
    final picker = ImagePicker();
    List<XFile> selectedImages = [];

    try {
      final pickedImages = await picker.pickMultiImage();
      if (selectedImages.length < 10) {
        selectedImages = pickedImages;
      } else {}
    } catch (e) {
      // Handle any errors that occur during the image picking process
      log("Image picking issue ${e.toString()}");
    }

    return selectedImages;
  }

  Future<XFile?> pickImages() async {
    // final picker = ImagePicker();
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        return pickedImage;
      } else {
        return null; // showDangerSnackBar( msg: "No image selected");
      }
    } catch (e) {
      log("Image picking issue ${e.toString()}");
    }
    return null;
  }
}
