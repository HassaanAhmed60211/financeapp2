import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_track_app/core/Model/income_model.dart';
import 'package:finance_track_app/core/Model/user_model.dart';
import 'package:finance_track_app/ui/bottom_nav/bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  void userSignUp(email, password, name, context) async {
    final auth = FirebaseAuth.instance;
    try {
      // Wait for user creation to complete
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Now, get the current user
      final user = auth.currentUser;
      debugPrint(user.toString());

      if (user != null) {
        await addUser(UserModel(
            userid: user.uid, name: name, email: email, imageUrl: ''));
        Get.to(() => const MyBottomNavBar());
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.code);
      if (e.code == 'email-already-in-use') {
        var snackbar = const SnackBar(
          content: Text('This email already exists'),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      } else {
        var snackbar = const SnackBar(
          content: Text('An error occurred during signup'),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    }
  }

  Future<void> addUser(UserModel User) async {
    final datauser = FirebaseFirestore.instance.collection('user');
    FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore db = FirebaseFirestore.instance;
    try {
      final user = auth.currentUser;
      if (user != null) {
        final uuserr = UserModel(
          userid: User.userid,
          email: User.email,
          name: User.name,
          imageUrl: '',
        );

        await datauser.doc(user.uid).set(uuserr.toMap());
        await db.collection('expense_analytics').doc(user.uid).set({
          'expenses': 0.0,
          'income': 0.0,
          'savings': 0.0,
        });
      }
    } catch (e) {
      print('Error adding user document: $e');
    }
  }
}
