import 'package:finance_track_app/core/utils.dart';
import 'package:finance_track_app/ui/bottom_nav/bottom_navcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

class MyBottomNavBar extends StatefulWidget {
  const MyBottomNavBar({Key? key}) : super(key: key);

  @override
  State<MyBottomNavBar> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyBottomNavBar> {
  /// Controller to handle PageView and also handles initial page
  final _pageController = PageController(initialPage: 0);
  int selectedIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final controller = Get.put(BottomNavBarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: controller.bottomBarPages, // Use the list of pages here
      ),
      bottomNavigationBar: WaterDropNavBar(
        bottomPadding: 20,
        backgroundColor: ColorConstraint.primeColor,
        inactiveIconColor: Colors.grey.shade400,
        waterDropColor: Colors.white,
        iconSize: 30,
        onItemSelected: (int index) {
          setState(() {
            selectedIndex = index;
          });
          _pageController.animateToPage(
            selectedIndex,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutQuad,
          );
        },
        selectedIndex: selectedIndex,
        barItems: <BarItem>[
          BarItem(
            filledIcon: Icons.house,
            outlinedIcon: Icons.house_outlined,
          ),
          BarItem(filledIcon: Icons.money, outlinedIcon: Icons.credit_card),
          BarItem(
            filledIcon: Icons.pie_chart,
            outlinedIcon: Icons.pie_chart_outline,
          ),
          BarItem(
            filledIcon: Icons.person_3,
            outlinedIcon: Icons.person_3_outlined,
          ),
        ],
      ),
    );
  }
}
