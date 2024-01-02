import 'package:finance_track_app/core/theme.dart';
import 'package:finance_track_app/core/utils.dart';
import 'package:finance_track_app/core/widgets/app_bar.dart';
import 'package:finance_track_app/core/widgets/custom_elevated.dart';
import 'package:finance_track_app/core/widgets/spaces_widget.dart';
import 'package:finance_track_app/core/widgets/text_widgets.dart';
import 'package:finance_track_app/ui/financial_goals/dialogs/add_dialog.dart';
import 'package:finance_track_app/ui/financial_goals/goal_controller.dart';
import 'package:finance_track_app/ui/financial_goals/widgets/goal_datalist.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FinancialGoals extends StatefulWidget {
  const FinancialGoals({super.key});

  @override
  State<FinancialGoals> createState() => _FinancialGoalsState();
}

class _FinancialGoalsState extends State<FinancialGoals> {
  final ThemeController _themeController = Get.put(ThemeController());

  GoalController controllergoal = Get.put(GoalController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: _themeController.isDarkMode.value
            ? Colors.black87
            : ColorConstraint().primaryColor,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: globalAppBar1('FINANCIAL GOALS')),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Spaces.mid,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(
                      () => customTextWidget(
                          'SET YOUR GOALS',
                          _themeController.isDarkMode.value
                              ? ColorConstraint().primaryColor
                              : ColorConstraint.secondaryColor,
                          FontWeight.w700,
                          15),
                    ),
                    customElevetedBtnWid(() {
                      showAddGoalDialog(context);
                    }, 'Add', 20, 100)
                  ],
                ),
                Spaces.mid,
                goalList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
