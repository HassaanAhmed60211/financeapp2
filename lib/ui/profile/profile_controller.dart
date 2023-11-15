import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  XFile? imagePaths;

  void setImagePath(XFile? path) async {
    imagePaths = path;
    print(imagePaths);

    update();
  }
}
