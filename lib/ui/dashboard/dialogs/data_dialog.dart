import 'package:finance_track_app/core/utils.dart';
import 'package:finance_track_app/core/widgets/custom_elevated.dart';
import 'package:finance_track_app/core/widgets/spaces_widget.dart';
import 'package:finance_track_app/ui/dashboard/dashboard_controller.dart';
import 'package:finance_track_app/ui/dashboard/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

TextEditingController expensename = TextEditingController();
TextEditingController expenseprice = TextEditingController();
DashboardController dashboardController = Get.put(DashboardController());
Future<void> showAddDialog(context) async {
  var totalIncomeVal = dashboardController.totalIncome.value;
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
                    controller: expensename,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                        labelText: 'Expense name',
                        labelStyle: TextStyle(color: Colors.black26),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black38, width: 1))),
                  ),
                  Spaces.mid,
                  TextFormField(
                    controller: expenseprice,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                        labelText: 'Expense price',
                        labelStyle: TextStyle(color: Colors.black26),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black38, width: 1))),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Builder(builder: (context) {
                    return customElevetedBtn(() {
                      if (totalIncomeVal > double.parse(expenseprice.text)) {
                        controllerdash.addData(
                            expensename.text, expenseprice.text, context);

                        expensename.clear();
                        expenseprice.clear();
                        Navigator.pop(context);
                      } else {
                        var snackbar = const SnackBar(
                          content: Text("Please Update your Income"),
                          backgroundColor: Colors.red,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        Navigator.pop(context);
                      }
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
