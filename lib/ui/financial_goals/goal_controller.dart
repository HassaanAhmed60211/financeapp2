import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_track_app/core/Model/goal_model.dart';
import 'package:finance_track_app/ui/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GoalController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxString username = ''.obs;
  RxBool convertToPKR = false.obs; // Track the selected currency
  RxDouble progressval = 0.0.obs;
  RxDouble percentage = 0.0.obs;
  RxDouble remainingperc = 0.0.obs;
  RxString nameNotification = ''.obs;
  RxDouble percNotification = 0.0.obs;
  RxString nameNotification1 = ''.obs;
  RxString percNotification1 = ''.obs;
  GoalModel? goalData;
  List<GoalModel>? data;

  @override
  void onInit() {
    fetchAllGoals();
    super.onInit();
    if (nameNotification.isNotEmpty) {
      NotificationService().showNotification(
          title: nameNotification.value,
          body:
              'Hey!! You are to close to complete your Goal. Your Goal is ${percNotification.value}% completed.');
    }
  }

  addData(String goalname, String curentsaving, String totalsaving) async {
    goalData = GoalModel(
        goalname: goalname,
        curentsaving: curentsaving,
        totalsaving: totalsaving);

    await _db
        .collection('goal')
        .doc(_auth.currentUser!.uid)
        .collection('all_goals')
        .add(goalData!.toJson());
    goalNotification();
    update();
  }

  void goalNotification() {
    for (int i = 0; i < data!.length; i++) {
      percentage.value = double.parse(data![i].curentsaving.toString()) /
          double.parse(data![i].totalsaving.toString()) *
          100;
      if (percentage.value > 95) {
        nameNotification.value = data![i].goalname.toString();
        percNotification.value = percentage.value;
      }
    }
  }

  double calculateProgress(double currentValue, double maxValue) {
    // Ensure that the values are within a valid range
    if (currentValue < 0.0) {
      currentValue = 0.0;
    }

    if (maxValue <= 0.0) {
      return 0.0; // Avoid division by zero
    }

    if (currentValue > maxValue) {
      currentValue = maxValue;
    }

    // Calculate the progress value between 0.0 and 1.0
    return currentValue / maxValue;
  }

  Future<List<GoalModel>?> fetchAllGoals() async {
    try {
      var querySnapshot = await _db
          .collection('goal')
          .doc(_auth.currentUser!.uid)
          .collection('all_goals')
          .get();

      data = querySnapshot.docs
          .map((document) => GoalModel.fromJson(document.data()))
          .toList();
      goalNotification();

      return data;
    } catch (e) {
      debugPrint('Error fetching transactions: $e');
      return [];
    }
  }

  updateData(int index, String amount, String name) async {
    if (double.parse(amount) >
        double.parse(data![index].totalsaving.toString())) {
      debugPrint('Not Updated');
    } else {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('goal')
          .doc(_auth.currentUser!.uid)
          .collection('all_goals')
          .where('goalname', isEqualTo: name)
          .get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in querySnapshot.docs) {
        await document.reference.update({
          'curentsaving': amount,
        });
      }
      goalNotification();
      update();
    }
  }

  deleteData(int index, String name) async {
    data!.removeAt(index);
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
        .collection('goal')
        .doc(_auth.currentUser!.uid)
        .collection('all_goals')
        .where('goalname', isEqualTo: name)
        .get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> document
        in querySnapshot.docs) {
      await document.reference.delete();
    }
    update();
  }
}
