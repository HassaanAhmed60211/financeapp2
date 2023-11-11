import 'package:finance_track_app/core/utils.dart';
import 'package:finance_track_app/core/widgets/custom_elevated.dart';
import 'package:finance_track_app/ui/dashboard/dashboard_controller.dart';
import 'package:finance_track_app/ui/dashboard/dashboard_page.dart';
import 'package:flutter/material.dart';

TextEditingController expensename = TextEditingController();
TextEditingController expenseprice = TextEditingController();
DashboardController controller = DashboardController();

Future<void> showUpdateDialog(context, index, text, price) async {
  expensename.text = text;
  expenseprice.text = price;
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Center(
            child: AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: expensename,
                    decoration:
                        const InputDecoration(labelText: 'Update Expense name'),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: expenseprice,
                    decoration: const InputDecoration(
                        labelText: 'Update Expense price'),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  customElevetedBtn(() {
                    controllerdash.updateData(
                        index, expensename.text, expenseprice.text);
                    expensename.clear();
                    expenseprice.clear();
                    Navigator.pop(context);
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
