import 'package:finance_track_app/core/theme.dart';
import 'package:finance_track_app/core/utils.dart';
import 'package:finance_track_app/core/widgets/spaces_widget.dart';
import 'package:finance_track_app/core/widgets/text_widgets.dart';
import 'package:finance_track_app/ui/bottom_nav/bottom_nav.dart';
import 'package:finance_track_app/ui/bottom_nav/bottom_navcontroller.dart';
import 'package:finance_track_app/ui/dashboard/dashboard_controller.dart';
import 'package:finance_track_app/ui/dashboard/dialogs/income_dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final ThemeController _themeController = Get.put(ThemeController());
final _auth = FirebaseAuth.instance;
DashboardController controllerdash = Get.put(DashboardController());
BottomNavBarController bottomNavController = Get.put(BottomNavBarController());
Widget customTrackContainer(context) {
  return Container(
    width: Get.width,
    height: Get.height * 0.22,
    decoration: BoxDecoration(
      color: _themeController.isDarkMode.value
          ? Colors.grey[200]
          : ColorConstraint().primaryColor,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.black38, width: 1),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
      child: Column(
        children: [
          SizedBox(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    bottomNavController.currentIndex.value = 2;
                    Get.to(() => MyBottomNavBar());
                  },
                  child: const Text(
                    'VIEW EXPENSE ANALYTICS',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline),
                  ),
                ),
                Obx(() => SizedBox(
                      height: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'PKR TO USD',
                            style: TextStyle(color: Colors.black, fontSize: 10),
                          ),
                          Switch(
                            inactiveTrackColor: Colors.black38,
                            value: controllerdash.convertToPKR.value,
                            onChanged: (value) {
                              controllerdash.convertToPKR.value = value;
                            },
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          Spaces().largeh(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: Image.asset('assets/svgviewer-png-output (1).png'),
                  ),
                  Obx(
                    () => customTextWidget(
                        controllerdash.convertToPKR.value
                            ? "\$${controllerdash.totalExpensesInUsd.toStringAsFixed(2)}"
                            : "Rs.${controllerdash.totalExpenses.toString()}",
                        const Color(0xffE53935),
                        FontWeight.w800,
                        14),
                  ),
                  customTextWidget(
                      'Expenses', const Color(0xff212121), FontWeight.w400, 16),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                      height: 40,
                      width: 40,
                      child:
                          Image.asset('assets/svgviewer-png-output (2).png')),
                  Obx(
                    () => GestureDetector(
                      onTap: () {
                        showIncomeDialog(context);
                      },
                      child: customTextWidget(
                          controllerdash.convertToPKR.value
                              ? "\$${controllerdash.totalIncomeInUsd.toStringAsFixed(2)}"
                              : "Rs.${controllerdash.totalIncome.toString()}",
                          const Color(0xff00897B),
                          FontWeight.w800,
                          14),
                    ),
                  ),
                  customTextWidget(
                      'Income', const Color(0xff212121), FontWeight.w400, 16),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                      height: 40,
                      width: 40,
                      child:
                          Image.asset('assets/svgviewer-png-output (3).png')),
                  Obx(
                    () => customTextWidget(
                        controllerdash.convertToPKR.value
                            ? "\$${controllerdash.remainingIncomeInUsd.toStringAsFixed(2)}"
                            : "Rs.${controllerdash.remainingIncome.toString()}",
                        const Color(0xff212121),
                        FontWeight.w800,
                        14),
                  ),
                  customTextWidget(
                      'Savings', const Color(0xff212121), FontWeight.w400, 16),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
