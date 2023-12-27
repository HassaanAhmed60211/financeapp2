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
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Observables
  RxString username = ''.obs;
  RxBool convertToPKR = false.obs;
  RxDouble totalIncomeInUsd = 0.0.obs;
  RxDouble totalExpensesInUsd = 0.0.obs;
  RxDouble remainingIncomeInUsd = 0.0.obs;

  List<String> perIncome = <String>[];
  List<dynamic> pExpense = <dynamic>[];
  List<dynamic> pSaving = <dynamic>[];
  List<dynamic> title = <dynamic>[];
  List<dynamic> timing = <dynamic>[];
  List<String> time = <String>[];
  double? price;
  ExpenseAnalyticsModel? dataAnalytics;
  IncomeModel? data;

  double remainingSavings = 0.0;
  double pkrValue = 0.0;

  @override
  void onInit() async {
    super.onInit();
    await _fetchIncomeData();
    fetchExchangeRate();
  }

  // Fetch user's income data
  Future<void> _fetchIncomeData() async {
    var incomeData = await _db
        .collection('expense_analytics')
        .doc(_auth.currentUser!.uid)
        .get();

    data = IncomeModel(
      expenses: incomeData['expenses'],
      income: incomeData['income'],
      savings: incomeData['savings'],
    );

    _updatePerIncome();
    _fetchExpenseGraph();
    update();
  }

  // Update perIncome list
  void _updatePerIncome() {
    perIncome.clear();
    for (var i = 5; i > 0; i--) {
      int val = data!.income! ~/ i;
      perIncome.add(val.toString());
    }
  }

  // Fetch expense graph data
  Future<void> _fetchExpenseGraph() async {
    var expenseGraph =
        await _db.collection('expense_graph').doc(_auth.currentUser!.uid).get();

    dataAnalytics = ExpenseAnalyticsModel(
      perExpense: expenseGraph['perExpense'],
      perIncome: expenseGraph['perIncome'],
      perSaving: expenseGraph['perSaving'],
      time: expenseGraph['time'],
    );

    update();
  }

  // Updated _updateExpenseGraph function
  Future<void> _updateExpenseGraph(Map<String, dynamic> newData) async {
    try {
      var expenseGraphDoc = await _db
          .collection('expense_graph')
          .doc(_auth.currentUser!.uid)
          .get();

      if (expenseGraphDoc.exists) {
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

        await _db
            .collection('expense_graph')
            .doc(_auth.currentUser!.uid)
            .update(dataAnalytics!.toJson());
      } else {
        pExpense.add(double.tryParse(newData['price'] ?? '0.0') ?? 0.0);
        pSaving.add(data!.savings);
        title.add(newData['text']);
        time.add(newData['time']);
        dataAnalytics = ExpenseAnalyticsModel(
            perExpense: pExpense, perSaving: pSaving, time: time, title: title);

        await _db
            .collection('expense_graph')
            .doc(_auth.currentUser!.uid)
            .set(dataAnalytics!.toJson());
      }
    } catch (e) {
      debugPrint('Error updating expense graph: $e');
    }
  }

  // Add transaction to Firebase
  Future<void> addData(String text, String price, context) async {
    var date = DateTime.now();

    Map<String, dynamic> newData = {
      'text': text,
      'price': price,
      'time': DateFormat.MMMMd().format(date),
      'month': DateFormat.MMMM().format(date),
    };

    await _db
        .collection('transactions')
        .doc(_auth.currentUser!.uid)
        .collection('add_transaction')
        .add(newData);

    _calculateTotalExpenses();
    await _updateExpenseGraph(newData);

    fetchAllTransaction();
    update();
  }

  // Update transaction in Firebase
  Future<void> updateData(String title, String price, String text) async {
    try {
      await _updateFirestoreData(title, price, text);
      _calculateTotalExpenses();
      fetchAllTransaction();
      update();
    } catch (e) {
      debugPrint('Error updating transactions: $e');
    }
  }

  Future<void> _updateFirestoreData(
      String title, String price, String text) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
        .collection('transactions')
        .doc(_auth.currentUser!.uid)
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
  }

  // Delete transaction from Firebase
  Future<void> deleteData(index, String searchText) async {
    try {
      // await _deleteFirestoreData(searchText);
      await _calTotalExpensesDelete(searchText);
      fetchAllTransaction();
      update();
    } catch (e) {
      debugPrint('Error deleting transactions: $e');
    }
  }

  // Future<void> _deleteFirestoreData(String searchText) async {
  //   QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
  //       .collection('transactions')
  //       .doc(_auth.currentUser!.uid)
  //       .collection('add_transaction')
  //       .where('text', isEqualTo: searchText)
  //       .get();

  // }

  Future<void> _calTotalExpensesDelete(searchText) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('transactions')
          .doc(_auth.currentUser!.uid)
          .collection('add_transaction')
          .where('text', isEqualTo: searchText)
          .get();
      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in querySnapshot.docs) {
        await document.reference.delete();
      }

      QuerySnapshot<Map<String, dynamic>> querySnapshot1 = await _db
          .collection('transactions')
          .doc(_auth.currentUser!.uid)
          .collection('add_transaction')
          .get(); // Recalculate expenses based on the remaining transactions
      data!.expenses = querySnapshot1.docs
          .map((document) => double.tryParse(document['price'] ?? "0.0") ?? 0.0)
          .fold(0.0, (previous, current) => previous! + current);

      IncomeModel incomeData = IncomeModel(
        expenses: data!.expenses,
      );

      await _db
          .collection('expense_analytics')
          .doc(_auth.currentUser!.uid)
          .update(incomeData.toJson());

      calculateRemainingIncome();
      update();
    } catch (e) {
      debugPrint('Error calculating total expenses: $e');
    }
  }

  // Update income in Firebase
  void updateIncome(double? income) async {
    if (income != null) {
      data!.income = income;
      update();
      _updatePerIncome();

      IncomeModel incomeData = IncomeModel(
        income: income,
        savings: data!.savings,
      );

      await _db
          .collection('expense_analytics')
          .doc(_auth.currentUser!.uid)
          .set(incomeData.toJson());
      await _db.collection('expense_graph').doc(_auth.currentUser!.uid).update({
        'perIncome': perIncome,
      });

      _calculateTotalExpenses();
      update();
    }
  }

  // Calculate total expenses from Firebase
  Future<void> _calculateTotalExpenses() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('transactions')
          .doc(_auth.currentUser!.uid)
          .collection('add_transaction')
          .get();
      debugPrint(querySnapshot.docs.length.toString());
      if (querySnapshot.docs.isNotEmpty) {
        data!.expenses = querySnapshot.docs
            .map((document) =>
                double.tryParse(document['price'] ?? "0.0") ?? 0.0)
            .fold(0.0, (previous, current) => previous! + current);
        debugPrint(data!.expenses.toString());

        IncomeModel incomeData = IncomeModel(
          expenses: data!.expenses,
        );

        await _db
            .collection('expense_analytics')
            .doc(_auth.currentUser!.uid)
            .update(incomeData.toJson());

        calculateRemainingIncome();
        update();
      } else {
        // Handle the case where there are no documents or querySnapshot is null
        debugPrint('No documents found in the transaction collection.');
      }
    } catch (e) {
      debugPrint('Error calculating total expenses: $e');
    }
  }

  // Fetch all transactions of the user
  Future<List<TransactionModel>> fetchAllTransaction() async {
    try {
      var querySnapshot = await _db
          .collection('transactions')
          .doc(_auth.currentUser!.uid)
          .collection('add_transaction')
          .get();

      return querySnapshot.docs
          .map((document) => TransactionModel.fromJson(document.data()))
          .toList();
    } catch (e) {
      debugPrint('Error fetching transactions: $e');
      return [];
    }
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
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance
            .collection('expense_analytics')
            .doc(_auth.currentUser!.uid)
            .get();
    if (documentSnapshot.exists) {
      double documentIncome = documentSnapshot.get('income') ?? 0.0;
      double documentExpenses = documentSnapshot.get('expenses') ?? 0.0;
      data!.savings = documentIncome - documentExpenses;
      IncomeModel incomeData = IncomeModel(
        savings: data!.savings,
      );
      await FirebaseFirestore.instance
          .collection('expense_analytics')
          .doc(_auth.currentUser!.uid)
          .update(incomeData.toJson());
    }
    update();
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
