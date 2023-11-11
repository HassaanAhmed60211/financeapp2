import 'package:finance_track_app/core/utils.dart';
import 'package:finance_track_app/core/widgets/custom_elevated.dart';
import 'package:finance_track_app/ui/dashboard/dashboard_page.dart';
import 'package:flutter/material.dart';

TextEditingController expensename = TextEditingController();
TextEditingController expenseprice = TextEditingController();
Future<void> showLoginDialog(context) async {
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
                        const InputDecoration(labelText: 'Expense name'),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: expenseprice,
                    decoration:
                        const InputDecoration(labelText: 'Expense price'),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  customElevetedBtn(() {
                    controllerdash.addData(expensename.text, expenseprice.text);
                    print(controllerdash.textData);
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
