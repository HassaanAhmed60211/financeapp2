import 'package:finance_track_app/core/utils.dart';
import 'package:finance_track_app/core/widgets/custom_elevated.dart';
import 'package:finance_track_app/ui/dashboard/dashboard_page.dart';
import 'package:flutter/material.dart';

TextEditingController incomecontroller = TextEditingController();
Future<void> showIncomeDialog(context) async {
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
                    controller: incomecontroller,
                    decoration:
                        const InputDecoration(labelText: 'Enter your income'),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  customElevetedBtn(() {
                    controllerdash
                        .updateIncome(double.tryParse(incomecontroller.text));
                    print(controllerdash.textData);
                    incomecontroller.clear();
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
