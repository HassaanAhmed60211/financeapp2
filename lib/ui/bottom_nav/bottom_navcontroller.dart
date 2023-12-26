import 'package:finance_track_app/ui/dashboard/dashboard_page.dart';
import 'package:finance_track_app/ui/expense_analytics/expense_analytics.dart';
import 'package:finance_track_app/ui/financial_goals/financial_goals.dart';
import 'package:finance_track_app/ui/profile/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import '../views/home/home_page.dart';
User? user = FirebaseAuth.instance.currentUser;
String id = user!.uid;

class BottomNavBarController extends GetxController {
  late PageController pageController;
  var currentIndex = 0.obs;
  GlobalKey bottomNavigationKey = GlobalKey();
  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    pageController.dispose();
  }

    final List<Widget> bottomBarPages = [
     DashboardPage(id),
    const FinancialGoals(),
     ExpenseAnalytics(),
    const ProfilePage(),
  ];

  List<Widget> pages = [
    DashboardPage(id),
    FinancialGoals(),
    ExpenseAnalytics(),
    ProfilePage(),
  ];
}
