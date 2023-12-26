import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_track_app/core/Model/expense_model.dart';
import 'package:finance_track_app/core/Model/income_model.dart';
import 'package:finance_track_app/core/Model/transaction_model.dart';
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

  RxDouble totalIncomeInUsd = 0.0.obs;
  RxDouble totalExpensesInUsd = 0.0.obs;
  RxDouble remainingIncomeInUsd = 0.0.obs;
  List<dynamic> pExpense = <dynamic>[];
  List<dynamic> pSaving = <dynamic>[];
  List<dynamic> title = <dynamic>[];
  List<dynamic> timing = <dynamic>[];
  List<String> time = <String>[];
  ExpenseAnalyticsModel? dataAnalytics;
  List<String> perIncome = <String>[];
  IncomeModel? data;

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
    data = IncomeModel(
        expenses: incomeData['expenses'],
        income: incomeData['income'],
        savings: incomeData['savings']);
    debugPrint(data!.expenses.toString());
    debugPrint(data!.income.toString());
    debugPrint(data!.savings.toString());

    for (var i = 5; i > 0; i--) {
      int val = data!.income! ~/ i;
      perIncome.add(val.toString());
    }
    update();

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
    // added on transaction ended
    await db
        .collection('transactions')
        .doc(auth.currentUser!.uid)
        .collection('add_transaction')
        .add(newData);
    //=======================================

    calculateTotalExpenses();
    //=======================================
    // Added expense graph

    await db
        .collection('expense_graph')
        .doc(auth.currentUser!.uid)
        .get()
        .then((docu) async {
      // if data exist so update the data
      if (docu.exists) {
        dataAnalytics?.perExpense?.add(
          double.tryParse(newData['price'] ?? '0.0') ?? 0.0,
        );
        dataAnalytics?.perSaving?.add(
          data!.savings,
        );
        dataAnalytics?.time?.add(
          newData['time'],
        );
        dataAnalytics?.title?.add(
          newData['text'],
        );

        await db
            .collection('expense_graph')
            .doc(auth.currentUser!.uid)
            .update(dataAnalytics!.toJson());
      } else {
        //else it set data inside user doc id
        pExpense.add(double.tryParse(newData['price'] ?? '0.0') ?? 0.0);
        pSaving.add(data!.savings);
        title.add(newData['text']);
        time.add(newData['time']);
        dataAnalytics = ExpenseAnalyticsModel(
            perExpense: pExpense, perSaving: pSaving, time: time, title: title);

        await db
            .collection('expense_graph')
            .doc(auth.currentUser!.uid)
            .set(dataAnalytics!.toJson());
      }
    });
    fetchAllTransaction();
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
      fetchAllTransaction();
      update();
    } catch (e) {
      print('Error deleting transactions: $e');
    }
  }

  // update income and it update on firebase
  void updateIncome(double? income) async {
    if (income != null) {
      data!.income = income;
      debugPrint(data!.income.toString());
      update();
      perIncome.clear();

      for (var i = 5; i > 0; i--) {
        int val = data!.income! ~/ i;
        perIncome.add(val.toString());
      }

      IncomeModel incomeData = IncomeModel(
        income: income,
        savings: data!.savings,
      );
      update();
      await db
          .collection('expense_analytics')
          .doc(auth.currentUser!.uid)
          .set(incomeData.toJson());
      await db.collection('expense_graph').doc(auth.currentUser!.uid).update({
        'perIncome': perIncome,
      });
      calculateTotalExpenses();
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
        data!.expenses = querySnapshot.docs
            .map((document) =>
                double.tryParse(document['price'] ?? '0.0') ?? 0.0)
            .fold(0.0, (previous, current) => previous! + current);
        calculateRemainingIncome();
        IncomeModel incomeData = IncomeModel(
          expenses: data!.expenses,
        );
        await db
            .collection('expense_analytics')
            .doc(auth.currentUser!.uid)
            .update(incomeData.toJson());
        calculateRemainingIncome();
        debugPrint(data!.expenses.toString());
        update();
      } else {
        data!.expenses = 0.0;
      }
      update();
    } catch (e) {
      print('Error calculating total expenses: $e');
    }
  }

  //Fetch all transaction of the user
  Stream<List<TransactionModel>> fetchAllTransaction() {
    return FirebaseFirestore.instance
        .collection('transactions')
        .doc(auth.currentUser!.uid)
        .collection('add_transaction')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((document) => TransactionModel.fromJson(document.data()))
          .toList();
    });
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

  void calculateRemainingIncome() async {
    data!.savings = data!.income! - data!.expenses!;
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance
            .collection('expense_analytics')
            .doc(auth.currentUser!.uid)
            .get();
    if (documentSnapshot.exists) {
      data!.savings = documentSnapshot.get('income') ??
          0.0 - documentSnapshot.get('expenses') ??
          0.0;
    }
    calculateRemainingIncome();
    IncomeModel incomeData = IncomeModel(
      savings: data!.savings,
    );
    update();
    await db
        .collection('expense_analytics')
        .doc(auth.currentUser!.uid)
        .update(incomeData.toJson());
  }

  void addDataToModel(
    double newPerExpense,
    double newPerSaving,
    String newTime,
  ) {
    dataAnalytics?.perExpense?.add(newPerExpense);
    dataAnalytics?.perSaving?.add(newPerSaving);
    dataAnalytics?.time?.add(newTime);
  }
}
