import 'package:finance_track_app/core/utils.dart';
import 'package:finance_track_app/core/widgets/custom_elevated.dart';
import 'package:finance_track_app/core/widgets/custom_snackbar.dart';
import 'package:finance_track_app/core/widgets/spaces_widget.dart';
import 'package:finance_track_app/ui/dashboard/dashboard_controller.dart';
import 'package:finance_track_app/ui/dashboard/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

TextEditingController incomecontroller = TextEditingController();
Future<void> showIncomeDialog(context) async {
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
                    keyboardType: TextInputType.number,
                    controller: incomecontroller,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                        labelText: 'Enter your income',
                        labelStyle: TextStyle(color: Colors.black26),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black38, width: 1))),
                  ),
                  Spaces.mid,
                  GetBuilder<DashboardController>(builder: (controller) {
                    return customElevetedBtn(() {
                      controllerdash
                          .updateIncome(double.tryParse(incomecontroller.text));

                      incomecontroller.clear();
                      Navigator.pop(context);
                      showSuccessSnackBar(
                          context: context,
                          label: 'successfully updated income');
                    }, 'Add', 20);
                  })
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
