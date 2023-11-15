import 'dart:async';

import 'package:finance_track_app/core/Model/data_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DashboardController extends GetxController {
  RxString username = ''.obs;
  RxBool convertToPKR = false.obs; // Track the selected currency

  RxDouble totalExpenses = 0.0.obs;
  RxDouble totalIncome = 18000.0.obs;
  RxDouble remainingIncome = 18000.0.obs;
  RxDouble totalIncomeInUsd = 63.81.obs;
  RxDouble totalExpensesInUsd = 0.0.obs;
  RxDouble remainingIncomeInUsd = 63.81.obs;
  List<String> time = <String>[];
  List<double> perExpense = <double>[];
  List<double> perSaving = <double>[];
  List<String> perIncome = <String>[];
  List<Map<String, dynamic>> textData = [];
  double remainingSavings = 0.0;
  double convertPkrToUsd(double amountInPkr) {
    // Assuming 1 USD is equal to 282 rupees
    return amountInPkr / 282;
  }

  addData(String text, String price) {
    var date = DateTime.now();
    Map<String, dynamic> newData = {
      'text': text,
      'price': price,
      'time': DateFormat.MMMMd().format(date),
    };
    textData.add(newData);
    print("DATAAAAA $textData");
    time.add(newData['time']);
    perExpense.add(double.tryParse(newData['price'] ?? '0.0') ?? 0.0);

    calculateTotalExpenses();
    calculateRemainingIncome();

    totalIncomeInUsd.value = convertTotalIncomeToUsd();

// Convert totalExpenses to USD
    totalExpensesInUsd.value = convertTotalExpensesToUsd();

// Convert remainingIncome to USD
    remainingIncomeInUsd.value = convertRemainingIncomeToUsd();
    int val1 = 1;
    for (var i = 5; i > 0; i--) {
      int val = (totalIncome.value / val1).toInt();
      perIncome.add(val.toString());
      val1++;
    }
    perIncome = perIncome.reversed.toList();
    print("FOR LOOP >> $perIncome");
    perSaving.add(remainingIncome.value);
    print("TIME HERE $time");
    print("DATAAAA HERE $perExpense");
    print("DATAAAA1 HERE $perSaving");
    update();
  }

  updateData(int index, String title, String price) {
    textData[index]['text'] = title;
    textData[index]['price'] = price;
    perExpense[index] =
        double.tryParse(textData[index]['price'] ?? '0.0') ?? 0.0;

    calculateTotalExpenses();
    calculateRemainingIncome();
    totalIncomeInUsd.value = convertTotalIncomeToUsd();

// Convert totalExpenses to USD
    totalExpensesInUsd.value = convertTotalExpensesToUsd();

// Convert remainingIncome to USD
    remainingIncomeInUsd.value = convertRemainingIncomeToUsd();
    perSaving[index] = remainingIncome.value;
    update();
  }

  deleteData(int index) {
    if (index >= 0 && index < textData.length) {
      textData.removeAt(index);
      calculateTotalExpenses();
      calculateRemainingIncome();
      totalIncomeInUsd.value = convertTotalIncomeToUsd();

// Convert totalExpenses to USD
      totalExpensesInUsd.value = convertTotalExpensesToUsd();

// Convert remainingIncome to USD
      remainingIncomeInUsd.value = convertRemainingIncomeToUsd();
      update();
    }
  }

  void updateIncome(double? income) {
    if (income != null) {
      totalIncome.value = income;
      for (var i = 5; i > 0; i--) {
        int val = (totalIncome.value / i).toInt();
        for (var j = 5; j > 0; j--) {
          perIncome[i - 1] = val.toString();
        }
      }
      perIncome = perIncome.reversed.toList();
      print('FOR LOOP >> $perIncome');
    }

    calculateTotalExpenses();
    calculateRemainingIncome();
    // Convert totalIncome to USD
    totalIncomeInUsd.value = convertTotalIncomeToUsd();

// Convert totalExpenses to USD
    totalExpensesInUsd.value = convertTotalExpensesToUsd();

// Convert remainingIncome to USD
    remainingIncomeInUsd.value = convertRemainingIncomeToUsd();

    update();
  }

  void calculateTotalExpenses() {
    totalExpenses.value = textData
        .map((item) => double.tryParse(item['price'] ?? '0.0') ?? 0.0)
        .fold(0.0, (previous, current) => previous + current);
  }

  void calculateRemainingIncome() {
    remainingIncome.value = totalIncome.value - totalExpenses.value;
  }

  double convertTotalIncomeToUsd() {
    return convertPkrToUsd(totalIncome.value);
  }

  // Conversion function for totalExpenses
  double convertTotalExpensesToUsd() {
    return convertPkrToUsd(totalExpenses.value);
  }

  // Conversion function for remainingIncome
  double convertRemainingIncomeToUsd() {
    return convertPkrToUsd(remainingIncome.value);
  }
}
