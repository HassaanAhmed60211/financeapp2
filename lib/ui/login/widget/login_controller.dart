import 'dart:async';

import 'package:finance_track_app/ui/dashboard/dashboard_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  void userLogin(email, password, context) async {
    final auth = await FirebaseAuth.instance;
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      String id = auth.currentUser!.uid;
      print(id);
      Get.to(DashboardPage(id));
    } on FirebaseAuthException catch (e) {
      String errorMessage = "";

      if (e.code == 'invalid-login-credentials') {
        var snackbar = SnackBar(content: Text("User not found"));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      } else {
        var snackbar = SnackBar(content: Text("Other exception"));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    }
  }
}
