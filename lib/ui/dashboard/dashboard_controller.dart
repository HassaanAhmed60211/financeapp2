import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_track_app/core/Model/expense_model.dart';
import 'package:finance_track_app/core/Model/income_model.dart';
import 'package:finance_track_app/core/Model/transaction_model.dart';
import 'package:finance_track_app/ui/expense_analytics/expense_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DashboardController extends GetxController {
  RxString username = ''.obs;
  RxBool convertToPKR = false.obs; // Track the selected currency
  final db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  RxDouble totalExpenses = 0.0.obs;
  RxDouble totalIncome = 0.0.obs;
  RxDouble remainingIncome = 0.0.obs;
  RxDouble totalIncomeInUsd = 0.0.obs;
  RxDouble totalExpensesInUsd = 0.0.obs;
  RxDouble remainingIncomeInUsd = 0.0.obs;
  List<String> time = <String>[];
  ExpenseAnalyticsModel? dataAnalytics;
  List<double> perExpense = <double>[];
  List<double> perSaving = <double>[];
  List<String> perIncome = <String>[];
  List<Map<String, dynamic>> textData = [];
  double remainingSavings = 0.0;
  double pkrValue = 0.0;

  @override
  void onInit() async {
    // Get called when controller is created
    super.onInit();
    var incomeData = await db
        .collection('expense_analytics')
        .doc(auth.currentUser!.uid)
        .get();

    fetchExchangeRate();
    totalIncome.value = incomeData['income'];
    for (var i = 5; i > 0; i--) {
      int val = totalIncome.value ~/ i;
      perIncome.add(val.toString());
    }
    remainingIncome.value = incomeData['savings'];

    calculateTotalExpenses();
    var expenseGraph =
        await db.collection('expense_graph').doc(auth.currentUser!.uid).get();

    dataAnalytics = ExpenseAnalyticsModel(
        perExpense: expenseGraph['perExpense'],
        perIncome: expenseGraph['perIncome'],
        perSaving: expenseGraph['perSaving'],
        time: expenseGraph['time']);
    update();
  }

//Add transaction in firebase
  addData(String text, String price, context) async {
    var date = DateTime.now();

    Map<String, dynamic> newData = {
      'text': text,
      'price': price,
      'time': DateFormat.MMMMd().format(date),
      'month': DateFormat.MMMM().format(date),
    };
    if (textData.isNotEmpty &&
        newData['month'] != textData[textData.length - 1]['month']) {
      time.clear();
      perExpense.clear();
      perSaving.clear();
    }
    textData.add(newData);
    time.add(newData['time']);
    perExpense.add(double.tryParse(newData['price'] ?? '0.0') ?? 0.0);

    await db
        .collection('transactions')
        .doc(auth.currentUser!.uid)
        .collection('add_transaction')
        .add(newData);

    calculateTotalExpenses();
    calculateRemainingIncome();
    perSaving.add(remainingIncome.value);
    dataAnalytics = ExpenseAnalyticsModel(
        perExpense: perExpense,
        time: time,
        perSaving: perSaving,
        perIncome: perIncome);
    await db
        .collection('expense_graph')
        .doc(auth.currentUser!.uid)
        .set(dataAnalytics!.toJson());
    update();
  }

//Update transaction in firebase
  updateData(String title, String price, String text) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('transactions')
              .doc(auth.currentUser!.uid)
              .collection('add_transaction')
              .where('text', isEqualTo: text)
              .get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in querySnapshot.docs) {
        await document.reference.update({
          'text': title,
          'price': price,
        });
      }

      calculateTotalExpenses();
      calculateRemainingIncome();
      fetchAllTransaction();
      update();
    } catch (e) {
      print('Error updating transactions: $e');
    }
  }

//Delete transaction from firebase
  Future<void> deleteData(index, String searchText) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('transactions')
              .doc(auth.currentUser!.uid)
              .collection('add_transaction')
              .where('text', isEqualTo: searchText)
              .get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in querySnapshot.docs) {
        await document.reference.delete();
      }
      calculateTotalExpenses();
      calculateRemainingIncome();
      fetchAllTransaction();
      calculateTotalExpenses();
      update();
    } catch (e) {
      print('Error deleting transactions: $e');
    }
  }

  // update income and it update on firebase
  void updateIncome(double? income) async {
    if (income != null) {
      totalIncome.value = income;
      debugPrint(totalIncome.value.toString());
      perIncome.clear();

      for (var i = 5; i > 0; i--) {
        int val = totalIncome.value ~/ i;
        perIncome.add(val.toString());
      }
      calculateTotalExpenses();
      calculateRemainingIncome();
      IncomeModel incomeData = IncomeModel(
        income: income,
        savings: remainingIncome.value,
      );
      await db
          .collection('expense_analytics')
          .doc(auth.currentUser!.uid)
          .set(incomeData.toJson());
      update();
    }
  }

  //calculate total expenses from firebase
  void calculateTotalExpenses() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('transactions')
              .doc(auth.currentUser!.uid)
              .collection('add_transaction')
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        totalExpenses.value = querySnapshot.docs
            .map((document) =>
                double.tryParse(document['price'] ?? '0.0') ?? 0.0)
            .fold(0.0, (previous, current) => previous + current);
        calculateRemainingIncome();
        IncomeModel incomeData = IncomeModel(
          expenses: totalExpenses.value,
        );
        await db
            .collection('expense_analytics')
            .doc(auth.currentUser!.uid)
            .update(incomeData.toJson());
        debugPrint(totalExpenses.value.toString());
      } else {
        totalExpenses.value = 0.0;
      }
      update();
    } catch (e) {
      print('Error calculating total expenses: $e');
    }
  }

  //Fetch all transaction of the user
  Future<List<TransactionModel>> fetchAllTransaction() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('transactions')
        .doc(auth.currentUser!.uid)
        .collection('add_transaction')
        .get();

    return querySnapshot.docs
        .map((document) => TransactionModel.fromJson(document.data()))
        .toList();
  }

  // fetch USD real time update exchange price for PKR
  void fetchExchangeRate() async {
    final response =
        await http.get(Uri.parse('https://open.er-api.com/v6/latest/USD'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      pkrValue = data['rates']['PKR'];
      update();
    } else {
      debugPrint('Failed to fetch data: ${response.statusCode}');
    }
  }

  double convertPkrToUsd(double amountInPkr) {
    return amountInPkr / double.parse(pkrValue.toStringAsFixed(1));
  }

  void calculateRemainingIncome() {
    remainingIncome.value = totalIncome.value - totalExpenses.value;
  }
}
