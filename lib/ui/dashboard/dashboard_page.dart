import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_track_app/core/theme.dart';
import 'package:finance_track_app/core/utils.dart';
import 'package:finance_track_app/core/widgets/app_bar.dart';
import 'package:finance_track_app/core/widgets/spaces_widget.dart';
import 'package:finance_track_app/ui/dashboard/dashboard_controller.dart';
import 'package:finance_track_app/ui/dashboard/widget/custom_trackcontainer.dart';
import 'package:finance_track_app/ui/dashboard/widget/custom_transcontainer.dart';
import 'package:finance_track_app/ui/dashboard/widget/graph.dart';
import 'package:finance_track_app/ui/financial_goals/goal_controller.dart';
import 'package:finance_track_app/ui/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardPage extends StatefulWidget {
  String id;
  DashboardPage(this.id, {super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

DashboardController controllerdash = Get.put(DashboardController());
GoalController goalController = Get.put(GoalController());

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getId();
    print(controllerdash.convertToPKR);

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    if (goalController.nameNotification.isNotEmpty) {
      NotificationService().showNotification(
          title: "Goal: ${goalController.nameNotification.value}",
          body:
              'Hey!! You are to close to complete your Goal. Your Goal is ${goalController.percNotification.value.toStringAsFixed(0)}% completed.');
    }
  }

  Stream<DocumentSnapshot> get _userStream {
    // Replace 'users' with the correct collection name
    return FirebaseFirestore.instance
        .collection('user')
        .doc(widget.id)
        .snapshots();
  }

  final ThemeController _themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: _themeController.isDarkMode.value
            ? Colors.black87
            : ColorConstraint().primaryColor,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: GlobalAppBar(_userStream, 'FINANCE TRACKER')),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Spaces.largeh,
                Obx(() => customTrackContainer(context)),
                Spaces.mid,
                customGraphChart(),
                Spaces.mid,
                customTransContainer(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
