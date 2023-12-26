import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_track_app/core/theme.dart';
import 'package:finance_track_app/core/utils.dart';
import 'package:finance_track_app/core/widgets/text_widgets.dart';
import 'package:finance_track_app/ui/login/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

final ThemeController _themeController = Get.put(ThemeController());
final _auth = FirebaseAuth.instance;

Widget GlobalAppBar(_userStream, text) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.transparent,
    leading: Padding(
      padding: const EdgeInsets.only(top: 10, left: 10),
      child: CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: StreamBuilder<DocumentSnapshot>(
          stream: _userStream,
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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

            return customTextWidget(userData['name'].toString().substring(0, 1),
                Colors.grey[900], FontWeight.w500, 18);
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
            text,
            _themeController.isDarkMode.value
                ? ColorConstraint().primaryColor
                : ColorConstraint.secondaryColor,
            FontWeight.w800,
            19),
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(top: 10, right: 3),
        child: Obx(
          () => Switch(
            activeColor: Colors.blue[900],
            activeTrackColor: Colors.blue.shade100,
            inactiveThumbColor: Colors.white,
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
  );
}

Widget GlobalAppBar1(text) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.transparent,
    automaticallyImplyLeading: false,
    centerTitle: true,
    title: Padding(
      padding: const EdgeInsets.only(
        top: 10,
      ),
      child: Obx(
        () => customTextWidget(
            text,
            _themeController.isDarkMode.value
                ? ColorConstraint().primaryColor
                : ColorConstraint.secondaryColor,
            FontWeight.w800,
            19),
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(top: 10, right: 3),
        child: Obx(
          () => Switch(
            activeColor: Colors.blue[900],
            activeTrackColor: Colors.blue.shade100,
            inactiveThumbColor: Colors.white,
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
  );
}
