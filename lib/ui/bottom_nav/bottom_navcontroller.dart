import 'package:finance_track_app/ui/dashboard/dashboard_page.dart';
import 'package:finance_track_app/ui/expense_analytics/expense_analytics.dart';
import 'package:finance_track_app/ui/financial_goals/financial_goals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import '../views/home/home_page.dart';
User? user = FirebaseAuth.instance.currentUser;
String id = user!.uid;

class BottomNavBarController extends GetxController {
  RxInt currentIndex = 0.obs;

  List<Widget> pages = [
    DashboardPage(id),
    FinancialGoals(),
    ExpenseAnalytics(),
    DashboardPage(id),
  ];
}
