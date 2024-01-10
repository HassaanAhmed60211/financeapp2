import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_track_app/core/theme.dart';
import 'package:finance_track_app/core/utils.dart';
import 'package:finance_track_app/core/widgets/text_widgets.dart';
import 'package:finance_track_app/ui/bottom_nav/bottom_navcontroller.dart';
import 'package:finance_track_app/ui/login/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final ThemeController _themeController = Get.put(ThemeController());
final _auth = FirebaseAuth.instance;
final bottomNavController = Get.find<BottomNavBarController>();

Widget globalAppBar(userStream, text) {
  return AppBar(
    surfaceTintColor: ColorConstraint.whiteColor,
    elevation: 0,
    backgroundColor: Colors.transparent,
    leading: Padding(
      padding: const EdgeInsets.only(top: 10, left: 10),
      child: InkWell(
        onTap: () {
          bottomNavController.changePage(3);
        },
        child: CircleAvatar(
          backgroundColor: ColorConstraint.primeColor,
          child: StreamBuilder<DocumentSnapshot>(
            stream: userStream,
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Icon(
                  Icons.person,
                  color: Colors.white,
                );
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Icon(
                  Icons.person,
                  color: Colors.white,
                );
              }

              Map<String, dynamic> userData =
                  snapshot.data!.data()! as Map<String, dynamic>;
              debugPrint(userData.toString());
              return customTextWidget(
                  userData['name'].toString().substring(0, 1),
                  Colors.white,
                  FontWeight.w500,
                  18);
              // Add more widgets to display other user details as needed
            },
          ),
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
            inactiveTrackColor: ColorConstraint.primeColor.withOpacity(0.7),
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

Widget globalAppBar1(text) {
  return AppBar(
    surfaceTintColor: ColorConstraint.whiteColor,
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
            inactiveTrackColor: ColorConstraint.primeColor.withOpacity(0.7),
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
