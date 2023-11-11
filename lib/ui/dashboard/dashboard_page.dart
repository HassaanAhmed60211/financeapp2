import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_track_app/core/Model/graph_model.dart';
import 'package:finance_track_app/core/theme.dart';
import 'package:finance_track_app/core/utils.dart';
import 'package:finance_track_app/core/widgets/app_bar.dart';
import 'package:finance_track_app/core/widgets/custom_elevated.dart';
import 'package:finance_track_app/core/widgets/graph_chart.dart';
import 'package:finance_track_app/core/widgets/spaces_widget.dart';
import 'package:finance_track_app/core/widgets/text_widgets.dart';
import 'package:finance_track_app/ui/dashboard/dashboard_controller.dart';
import 'package:finance_track_app/ui/dashboard/data_dialog.dart';
import 'package:finance_track_app/ui/dashboard/income_dialogs.dart';
import 'package:finance_track_app/ui/dashboard/update_dialog.dart';
import 'package:finance_track_app/ui/login/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class DashboardPage extends StatefulWidget {
  String id;
  DashboardPage(this.id, {super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

DashboardController controllerdash = Get.put(DashboardController());

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getId();
    print(controllerdash.convertToPKR);
  }

  Stream<DocumentSnapshot> get _userStream {
    // Replace 'users' with the correct collection name
    return FirebaseFirestore.instance
        .collection('user')
        .doc(widget.id)
        .snapshots();
  }

  final ThemeController _themeController = Get.put(ThemeController());
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: _themeController.isDarkMode.value
            ? Colors.transparent
            : ColorConstraint().primaryColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: StreamBuilder<DocumentSnapshot>(
                stream: _userStream,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Icon(
                      Icons.person,
                      color: Colors.black45,
                    );
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Icon(
                      Icons.person,
                    );
                  }

                  Map<String, dynamic> userData =
                      snapshot.data!.data()! as Map<String, dynamic>;

                  return customTextWidget(
                      userData['name'].toString().substring(0, 1),
                      Colors.grey[900],
                      FontWeight.w500,
                      18);
                  // Add more widgets to display other user details as needed
                },
              ),
            ),
          ),
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: Obx(
              () => customTextWidget(
                  "FINANCE TRACKER",
                  _themeController.isDarkMode.value
                      ? ColorConstraint().primaryColor
                      : ColorConstraint().secondaryColor,
                  FontWeight.w800,
                  19),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 3),
              child: Obx(
                () => Switch(
                  inactiveTrackColor: Colors.grey,
                  value: _themeController.isDarkMode.value,
                  onChanged: (value) => _themeController.toggleTheme(),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 5, right: 10),
                child: IconButton(
                    onPressed: () {
                      _auth.signOut();
                      Get.to(LoginView());
                    },
                    icon: Obx(
                      () => Icon(
                        Icons.logout,
                        color: _themeController.isDarkMode.value
                            ? ColorConstraint().primaryColor
                            : Colors.grey[900],
                      ),
                    ))),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Spaces().largeh(),
                Obx(
                  () => Container(
                    width: Get.width,
                    height: Get.height * 0.2,
                    decoration: BoxDecoration(
                      color: _themeController.isDarkMode.value
                          ? Colors.grey[200]
                          : ColorConstraint().primaryColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black38, width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 30.0),
                      child: Column(
                        children: [
                          Obx(() => SizedBox(
                                height: 10,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Text(
                                      'PKR TO USD',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 10),
                                    ),
                                    Switch(
                                      inactiveTrackColor: Colors.black38,
                                      value: controllerdash.convertToPKR.value,
                                      onChanged: (value) {
                                        controllerdash.convertToPKR.value =
                                            value;
                                      },
                                    ),
                                  ],
                                ),
                              )),
                          Spaces().largeh(),
                          Spaces().largeh(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Image.asset(
                                        'assets/svgviewer-png-output (1).png'),
                                  ),
                                  Obx(
                                    () => customTextWidget(
                                        controllerdash.convertToPKR.value
                                            ? "\$${controllerdash.totalExpensesInUsd.toStringAsFixed(2)}"
                                            : "Rs.${controllerdash.totalExpenses.toString()}",
                                        const Color(0xffE53935),
                                        FontWeight.w800,
                                        14),
                                  ),
                                  customTextWidget(
                                      'Expenses',
                                      const Color(0xff212121),
                                      FontWeight.w400,
                                      16),
                                ],
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: Image.asset(
                                          'assets/svgviewer-png-output (2).png')),
                                  Obx(
                                    () => GestureDetector(
                                      onTap: () {
                                        showIncomeDialog(context);
                                      },
                                      child: customTextWidget(
                                          controllerdash.convertToPKR.value
                                              ? "\$${controllerdash.totalIncomeInUsd.toStringAsFixed(2)}"
                                              : "Rs.${controllerdash.totalIncome.toString()}",
                                          const Color(0xff00897B),
                                          FontWeight.w800,
                                          14),
                                    ),
                                  ),
                                  customTextWidget(
                                      'Income',
                                      const Color(0xff212121),
                                      FontWeight.w400,
                                      16),
                                ],
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: Image.asset(
                                          'assets/svgviewer-png-output (3).png')),
                                  Obx(
                                    () => customTextWidget(
                                        controllerdash.convertToPKR.value
                                            ? "\$${controllerdash.remainingIncomeInUsd.toStringAsFixed(2)}"
                                            : "Rs.${controllerdash.remainingIncome.toString()}",
                                        const Color(0xff212121),
                                        FontWeight.w800,
                                        14),
                                  ),
                                  customTextWidget(
                                      'Savings',
                                      const Color(0xff212121),
                                      FontWeight.w400,
                                      16),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Spaces().midh(),
                Obx(
                  () {
                    return GraphChart(
                      data: [
                        GraphSeries(
                          label: 'Income',
                          price: double.parse(
                              controllerdash.totalIncome.toString()),
                          barColor:
                              charts.ColorUtil.fromDartColor(Colors.green),
                        ),
                        GraphSeries(
                          label: 'Expenses',
                          price: double.parse(
                              controllerdash.totalExpenses.toString()),
                          barColor: charts.ColorUtil.fromDartColor(Colors.red),
                        ),
                        GraphSeries(
                          label: 'Savings',
                          price: double.parse(
                              controllerdash.remainingIncome.toString()),
                          barColor:
                              charts.ColorUtil.fromDartColor(Colors.blueGrey),
                        ),
                      ],
                    );
                  },
                ),
                Spaces().midh(),
                Obx(
                  () => Container(
                    width: Get.width,
                    height: Get.height,
                    decoration: BoxDecoration(
                      color: _themeController.isDarkMode.value
                          ? Colors.grey[200]
                          : ColorConstraint().primaryColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black38, width: 1),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customTextWidget('Transactions', Colors.black,
                                    FontWeight.w700, 21),
                                customElevetedBtn(() {
                                  showLoginDialog(context);
                                }, 'Add', 20)
                              ],
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controllerdash.textData.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> data =
                                    controllerdash.textData[index];

                                return Container();
                              },
                            ),
                            GetBuilder<DashboardController>(
                                builder: (controller) {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: controller.textData.length,
                                  itemBuilder: (context, index) {
                                    return controller.textData.isEmpty
                                        ? const Center(
                                            child: SizedBox(
                                            height: 200,
                                            child: Text("No Data"),
                                          ))
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Card(
                                              color: Colors.blue[900],
                                              child: Obx(() => ListTile(
                                                    title: Text(controller
                                                                .textData[index]
                                                            ['text'] ??
                                                        ''),
                                                    subtitle: Text(controller
                                                            .convertToPKR.value
                                                        ? "\$${controller.convertPkrToUsd(double.parse(controller.textData[index]['price'])).toStringAsFixed(2)}"
                                                        : "Rs.${controller.textData[index]['price']}"),
                                                    trailing: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        IconButton(
                                                          icon: const Icon(
                                                              Icons.edit),
                                                          onPressed: () {
                                                            String text =
                                                                controllerdash
                                                                        .textData[
                                                                    index]['text'];
                                                            String price =
                                                                controllerdash
                                                                        .textData[
                                                                    index]['price'];
                                                            showUpdateDialog(
                                                                context,
                                                                index,
                                                                text,
                                                                price);
                                                          },
                                                        ),
                                                        Spaces().smallh(),
                                                        IconButton(
                                                          icon: const Icon(
                                                              Icons.delete),
                                                          onPressed: () {
                                                            controller
                                                                .deleteData(
                                                                    index);
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                          );
                                  });
                            })
                          ],
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
