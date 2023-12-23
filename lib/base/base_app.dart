import 'package:finance_track_app/core/utils.dart';
import 'package:finance_track_app/ui/bottom_nav/bottom_nav.dart';
import 'package:finance_track_app/ui/dashboard/dashboard_page.dart';
import 'package:finance_track_app/ui/login/login_view.dart';
import 'package:finance_track_app/ui/splash/splash_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FinanaceTrackingApp extends StatelessWidget {
  FinanaceTrackingApp({super.key});

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: user != null ? MyBottomNavBar() : SplashScreen(),
    );
  }
}
