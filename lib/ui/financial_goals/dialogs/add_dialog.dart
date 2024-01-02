import 'package:finance_track_app/core/utils.dart';
import 'package:finance_track_app/core/widgets/custom_elevated.dart';
import 'package:finance_track_app/core/widgets/custom_snackbar.dart';
import 'package:finance_track_app/core/widgets/spaces_widget.dart';
import 'package:finance_track_app/ui/financial_goals/goal_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> showAddGoalDialog(context) async {
  TextEditingController goalname = TextEditingController();
  TextEditingController goalcurrentsaving = TextEditingController();
  TextEditingController goaltotalsaving = TextEditingController();

  GoalController controller = Get.put(GoalController());
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
                    controller: goalname,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                        labelText: 'Goal name',
                        labelStyle: TextStyle(color: Colors.black26),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black38, width: 1))),
                  ),
                  Spaces.mid,
                  TextFormField(
                    controller: goalcurrentsaving,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                        labelText: 'Enter the amount you have',
                        labelStyle: TextStyle(color: Colors.black26),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black38, width: 1))),
                  ),
                  Spaces.mid,
                  TextFormField(
                    controller: goaltotalsaving,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                        labelText: 'Set goal amount',
                        labelStyle: TextStyle(color: Colors.black26),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black38, width: 1))),
                  ),
                  Spaces.mid,
                  customElevetedBtn(() {
                    if (double.parse(goalcurrentsaving.text.toString()) >
                        double.parse(goaltotalsaving.text.toString())) {
                      var snackbar = const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Please input the correct Amount'));
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    } else {
                      controller.addData(goalname.text, goalcurrentsaving.text,
                          goaltotalsaving.text);

                      goalname.clear();
                      goalcurrentsaving.clear();
                      goaltotalsaving.clear();
                      Navigator.pop(context);
                      showSuccessSnackBar(
                          context: context, label: 'successfully goal added');
                    }
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
