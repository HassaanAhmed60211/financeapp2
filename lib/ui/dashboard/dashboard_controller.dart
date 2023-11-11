import 'dart:async';

import 'package:finance_track_app/core/Model/data_model.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  RxString username = ''.obs;
  RxBool convertToPKR = false.obs; // Track the selected currency

  RxDouble totalExpenses = 0.0.obs;
  RxDouble totalIncome = 18000.0.obs;
  RxDouble remainingIncome = 18000.0.obs;
  RxDouble totalIncomeInUsd = 63.81.obs;
  RxDouble totalExpensesInUsd = 0.0.obs;
  RxDouble remainingIncomeInUsd = 63.81.obs;
  List<Map<String, dynamic>> textData = [];
  double convertPkrToUsd(double amountInPkr) {
    // Assuming 1 USD is equal to 282 rupees
    return amountInPkr / 282;
  }

  addData(String text, String price) {
    Map<String, dynamic> newData = {
      'text': text,
      'price': price,
    };
    textData.add(newData);
    calculateTotalExpenses();
    calculateRemainingIncome();
    totalIncomeInUsd.value = convertTotalIncomeToUsd();

// Convert totalExpenses to USD
    totalExpensesInUsd.value = convertTotalExpensesToUsd();

// Convert remainingIncome to USD
    remainingIncomeInUsd.value = convertRemainingIncomeToUsd();
    update();
  }

  updateData(int index, String title, String price) {
    textData[index]['text'] = title;
    textData[index]['price'] = price;
    calculateTotalExpenses();
    calculateRemainingIncome();
    totalIncomeInUsd.value = convertTotalIncomeToUsd();

// Convert totalExpenses to USD
    totalExpensesInUsd.value = convertTotalExpensesToUsd();

// Convert remainingIncome to USD
    remainingIncomeInUsd.value = convertRemainingIncomeToUsd();
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
