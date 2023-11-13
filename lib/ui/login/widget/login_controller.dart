import 'dart:async';

import 'package:finance_track_app/ui/dashboard/dashboard_page.dart';
import 'package:finance_track_app/ui/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  void userLogin(email, password, context) async {
    final auth = FirebaseAuth.instance;
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Get.to(() => Home());
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "";

      if (e.code == 'invalid-login-credentials') {
        var snackbar = const SnackBar(content: Text("User not found"));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      } else {
        var snackbar = const SnackBar(content: Text("Other exception"));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    }
  }
}
