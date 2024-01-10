import 'package:finance_track_app/ui/bottom_nav/bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  void userLogin(email, password, context) async {
    final auth = FirebaseAuth.instance;
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      final user = auth.currentUser;
      debugPrint(user.toString());
      if (user != null) {
        Get.to(() => const MyBottomNavBar());
        emailcontroller.clear();
        passcontroller.clear();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        var snackbar = const SnackBar(
          content: Text('No user found for that email.',
            style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      } else if (e.code == 'wrong-password') {
        var snackbar = const SnackBar(
          content: Text('Wrong password provided',
            style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        var snackbar = const SnackBar(
          content: Text('invalid login credentials',
            style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    }
  }
}
