import 'package:finance_track_app/core/utils.dart';
import 'package:finance_track_app/core/widgets/custom_elevated.dart';
import 'package:finance_track_app/core/widgets/spaces_widget.dart';
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
                  Spaces().midh(),
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
