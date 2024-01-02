import 'package:finance_track_app/core/Model/income_model.dart';
import 'package:finance_track_app/core/theme.dart';
import 'package:finance_track_app/core/utils.dart';
import 'package:finance_track_app/core/widgets/spaces_widget.dart';
import 'package:finance_track_app/core/widgets/text_widgets.dart';
import 'package:finance_track_app/ui/bottom_nav/bottom_navcontroller.dart';
import 'package:finance_track_app/ui/dashboard/dashboard_controller.dart';
import 'package:finance_track_app/ui/dashboard/dialogs/income_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final ThemeController _themeController = Get.put(ThemeController());
DashboardController controllerdash = Get.put(DashboardController());
final bottomNavController = Get.find<BottomNavBarController>();

Widget customTrackContainer(context) {
  return Container(
    width: Get.width,
    height: Get.height * 0.24,
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
                    bottomNavController.changePage(2);
                  },
                  child: const Text(
                    'VIEW EXPENSE ANALYTICS',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                Obx(() => SizedBox(
                      height: Get.height * 0.2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'PKR TO USD',
                            style: TextStyle(color: Colors.black, fontSize: 10),
                          ),
                          Switch(
                            activeColor: Colors.blue[900],
                            activeTrackColor: Colors.blue.shade100,
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor:
                                ColorConstraint.primeColor.withOpacity(0.7),
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
          Spaces.mid,
          GetBuilder<DashboardController>(builder: (controlle) {
            return FutureBuilder<IncomeModel?>(
              future: controlle.fetchIncomeData(),
              builder: (context, AsyncSnapshot<IncomeModel?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: Get.height * 0.1,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: ColorConstraint.primeColor,
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: customTextWidget(
                      snapshot.error.toString(),
                      Colors.black,
                      FontWeight.w500,
                      12,
                    ),
                  );
                } else if (snapshot.data == null) {
                  return Center(
                    child: customTextWidget(
                      'No data available',
                      Colors.black,
                      FontWeight.w500,
                      12,
                    ),
                  );
                } else {
                  final data = snapshot.data!;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: Image.asset(
                                'assets/svgviewer-png-output (1).png'),
                          ),
                          Obx(
                            () => customTextWidget(
                              controllerdash.convertToPKR.value
                                  ? "\$${controllerdash.convertPkrToUsd(data.expenses?.toDouble() ?? 0.0).toStringAsFixed(2)}"
                                  : "Rs.${data.expenses ?? 0.0}",
                              const Color(0xffE53935),
                              FontWeight.w800,
                              14,
                            ),
                          ),
                          customTextWidget(
                            'Expenses',
                            const Color(0xff212121),
                            FontWeight.w400,
                            16,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: Image.asset(
                                'assets/svgviewer-png-output (2).png'),
                          ),
                          GestureDetector(
                            onTap: () {
                              showIncomeDialog(context);
                            },
                            child: Obx(
                              () => customTextWidget(
                                controllerdash.convertToPKR.value
                                    ? "\$${controllerdash.convertPkrToUsd(data.income?.toDouble() ?? 0.0).toStringAsFixed(2)}"
                                    : "Rs.${data.income ?? 0.0}",
                                const Color(0xff00897B),
                                FontWeight.w800,
                                14,
                              ),
                            ),
                          ),
                          customTextWidget(
                            'Income',
                            const Color(0xff212121),
                            FontWeight.w400,
                            16,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: Image.asset(
                                'assets/svgviewer-png-output (3).png'),
                          ),
                          Obx(
                            () => customTextWidget(
                              controllerdash.convertToPKR.value
                                  ? "\$${controllerdash.convertPkrToUsd(data.savings?.toDouble() ?? 0.0).toStringAsFixed(2)}"
                                  : "Rs.${data.savings ?? 0.0}",
                              const Color(0xff212121),
                              FontWeight.w800,
                              14,
                            ),
                          ),
                          customTextWidget(
                            'Savings',
                            const Color(0xff212121),
                            FontWeight.w400,
                            16,
                          ),
                        ],
                      ),
                    ],
                  );
                }
              },
            );
          }),
        ],
      ),
    ),
  );
}
