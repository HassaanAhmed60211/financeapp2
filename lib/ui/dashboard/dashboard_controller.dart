import 'dart:async';

import 'package:finance_track_app/core/Model/data_model.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  RxString username = ''.obs;

  RxDouble totalExpenses = 0.0.obs;
  RxDouble totalIncome = 18000.0.obs;
  RxDouble remainingIncome = 18000.0.obs;
  List<Map<String, dynamic>> textData = [];

  addData(String text, String price) {
    Map<String, dynamic> newData = {
      'text': text,
      'price': price,
    };
    textData.add(newData);
    calculateTotalExpenses();
    calculateRemainingIncome();
    update();
  }

  updateData(int index, String title, String price) {
    textData[index]['text'] = title;
    textData[index]['price'] = price;
    calculateTotalExpenses();
    calculateRemainingIncome();
    update();
  }

  deleteData(int index) {
    if (index >= 0 && index < textData.length) {
      textData.removeAt(index);
      calculateTotalExpenses();
      calculateRemainingIncome();
      update();
    }
  }

  void updateIncome(double? income) {
    if (income != null) {
      totalIncome.value = income;
    }
    calculateTotalExpenses();
    calculateRemainingIncome();

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
}
