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
import 'package:finance_track_app/ui/dashboard/widget/custom_trackcontainer.dart';
import 'package:finance_track_app/ui/dashboard/widget/custom_transcontainer.dart';
import 'package:finance_track_app/ui/dashboard/widget/graph.dart';
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
                
                Spaces().largeh(),
                Obx(() => customTrackContainer(context)),
                Spaces().midh(),
                Obx(
                  () {
                    return customGraphChart();
                  },
                ),
                Spaces().midh(),
                Obx(
                  () => customTransContainer(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
