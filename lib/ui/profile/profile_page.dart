import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_track_app/core/theme.dart';
import 'package:finance_track_app/core/utils.dart';
import 'package:finance_track_app/core/widgets/app_bar.dart';
import 'package:finance_track_app/core/widgets/spaces_widget.dart';
import 'package:finance_track_app/core/widgets/text_widgets.dart';
import 'package:finance_track_app/ui/bottom_nav/bottom_navcontroller.dart';
import 'package:finance_track_app/ui/profile/profile_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:badges/badges.dart' as bdg;
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ThemeController _themeController = Get.put(ThemeController());
  final ImagePickerUtil imagePickerUtil = ImagePickerUtil();
  ProfileController controller = Get.put(ProfileController());
  late Stream<DocumentSnapshot<Map<String, dynamic>>> personnalData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    personnalData = FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: _themeController.isDarkMode.value
            ? Colors.black87
            : ColorConstraint().primaryColor,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: GlobalAppBar1('MY PROFILE')),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spaces().largeh(),
              Spaces().largeh(),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 85,
                      backgroundColor: Colors.grey.shade200,
                      child: GetBuilder<ProfileController>(
                        builder: (controller) {
                          return CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 80,
                            backgroundImage: controller.imagePaths != null
                                ? Image.file(File(controller.imagePaths!.path))
                                    .image
                                : AssetImage('assets/person-image.png'),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 1,
                      right: 1,
                      child: GestureDetector(
                        onTap: () async {
                          XFile? image = await imagePickerUtil.pickImages();
                          if (image != null) {
                            controller.setImagePath(image);
                          }
                        },
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Icon(Icons.add_a_photo,
                                color: ColorConstraint.primaryLightColor),
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 3,
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  50,
                                ),
                              ),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(2, 4),
                                  color: Colors.black.withOpacity(
                                    0.3,
                                  ),
                                  blurRadius: 3,
                                ),
                              ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<DocumentSnapshot>(
                  stream: personnalData,
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        width: Get.width,
                        child: Column(
                          children: [
                            Spaces().largeh(),
                            Spaces().largeh(),
                            customTextWidget(
                                snapshot.data!['email'],
                                _themeController.isDarkMode.value
                                    ? ColorConstraint().primaryColor
                                    : ColorConstraint().secondaryColor,
                                FontWeight.w800,
                                21),
                            Spaces().largeh(),
                            customTextWidget(
                                snapshot.data!['name'],
                                _themeController.isDarkMode.value
                                    ? ColorConstraint().primaryColor
                                    : ColorConstraint().secondaryColor,
                                FontWeight.w800,
                                21),
                          ],
                        ),
                      );
                    }
                    return CircularProgressIndicator();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
