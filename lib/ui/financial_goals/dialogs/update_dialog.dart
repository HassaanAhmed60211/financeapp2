import 'package:finance_track_app/core/utils.dart';
import 'package:finance_track_app/core/widgets/custom_elevated.dart';
import 'package:finance_track_app/core/widgets/custom_snackbar.dart';
import 'package:finance_track_app/core/widgets/spaces_widget.dart';
import 'package:finance_track_app/ui/financial_goals/goal_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> showUpdateGoalDialog(context, index, amount, text) async {
  TextEditingController updatesavings = TextEditingController();
  GoalController controllergoal = Get.put(GoalController());
  updatesavings.text = amount;
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Center(
            child: AlertDialog(
              backgroundColor: ColorConstraint().primaryColor,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: updatesavings,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                        labelText: 'Update amount you have for this goal',
                        labelStyle: TextStyle(color: Colors.black26),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black38, width: 1))),
                  ),
                  Spaces.mid,
                  customElevetedBtn(() {
                    debugPrint(text);
                    controllergoal.updateData(
                        index, updatesavings.text, text, context);
                    updatesavings.clear();

                    Navigator.pop(context);
                    showSuccessSnackBar(
                        context: context, label: 'successfully goal updated');
                  }, 'Add', 20)
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
