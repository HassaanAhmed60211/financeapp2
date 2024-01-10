import 'package:finance_track_app/ui/dashboard/dashboard_page.dart';
import 'package:finance_track_app/ui/expense_analytics/expense_analytics.dart';
import 'package:finance_track_app/ui/financial_goals/financial_goals.dart';
import 'package:finance_track_app/ui/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import '../views/home/home_page.dart';

class BottomNavBarController extends GetxController {
  RxInt selectedIndex = 0.obs;
  final pageController = PageController(initialPage: 0);

  void changePage(int index) {
    selectedIndex.value = index;
    // debugPrint(id.toString());
  }

  GlobalKey bottomNavigationKey = GlobalKey();

  @override
  void onClose() {
    pageController.dispose();
  }

  final List<Widget> bottomBarPages = [
    const DashboardPage(),
    const FinancialGoals(),
    ExpenseAnalytics(),
    const ProfilePage(),
  ];
}
