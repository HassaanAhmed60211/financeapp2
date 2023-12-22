import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  XFile? imagePaths;
  RxString imageUrl = ''.obs;
  CollectionReference users = FirebaseFirestore.instance.collection('user');
  final user = FirebaseAuth.instance.currentUser;
  bool isVal = false;

  void setImagePath(XFile? path) async {
    imagePaths = path;
    final user = FirebaseAuth.instance.currentUser;
    final storageRef = FirebaseStorage.instance.ref();
    String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
    final mountainsRef = storageRef.child("${user!.uid}/$uniqueName");
    try {
      await mountainsRef.putFile(File(imagePaths!.path));
      imageUrl.value = await mountainsRef.getDownloadURL();
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
    }
    updateUser();

    update();
  }

  void isValue() {
    isVal = true;
    update();
  }

  void isNotValue() {
    isVal = false;
    update();
  }

  Future<void> updateUser() {
    return users.doc(user!.uid).update({'imageUrl': imageUrl.value});
  }

  Future<void> updateName(text) {
    return users.doc(user!.uid).update({'name': text});
  }
}
