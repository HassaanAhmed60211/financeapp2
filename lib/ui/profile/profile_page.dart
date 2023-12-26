import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_track_app/core/theme.dart';
import 'package:finance_track_app/core/utils.dart';
import 'package:finance_track_app/core/widgets/app_bar.dart';
import 'package:finance_track_app/core/widgets/spaces_widget.dart';
import 'package:finance_track_app/core/widgets/text_widgets.dart';
import 'package:finance_track_app/ui/dashboard/widget/custom_trackcontainer.dart';
import 'package:finance_track_app/ui/login/widget/bottom_sheet.dart';
import 'package:finance_track_app/ui/profile/profile_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ThemeController _themeController = Get.put(ThemeController());
  final ImagePickerUtil imagePickerUtil = ImagePickerUtil();
  ProfileController controller = Get.put(ProfileController());
  late Stream<DocumentSnapshot<Map<String, dynamic>>> personalData;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    personalData = FirebaseFirestore.instance
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
          child: GlobalAppBar1('MY PROFILE'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spaces.large,
              Spaces.large,
              Center(
                child: Stack(
                  children: [
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('user')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(
                            color: Colors.blue,
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          String imageUrl = snapshot.data?['imageUrl'] ??
                              'https://res.cloudinary.com/dcub1wonq/image/upload/v1701352634/ijfy0uytq6rbmt1qpgtp.png';

                          if (imageUrl.isEmpty) {
                            imageUrl =
                                'https://res.cloudinary.com/dcub1wonq/image/upload/v1701352634/ijfy0uytq6rbmt1qpgtp.png';
                          }

                          return GetBuilder<ProfileController>(
                            builder: (controller) {
                              return CircleAvatar(
                                radius: 85,
                                backgroundColor: Colors.grey[300],
                                child: CircleAvatar(
                                  radius: 80,
                                  backgroundColor: Colors.grey.shade300,
                                  child: controller.isVal
                                      ? Container(
                                          child:
                                              const CircularProgressIndicator(
                                            color: Colors.blue,
                                          ),
                                        )
                                      : CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: 80,
                                          backgroundImage:
                                              NetworkImage(imageUrl),
                                        ),
                                ),
                              );
                            },
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                    Positioned(
                      bottom: 1,
                      right: 1,
                      child: GestureDetector(
                        onTap: () async {
                          XFile? image = await imagePickerUtil.pickImages();
                          if (image != null) {
                            controller.setImagePath(image);
                            controller.isValue();
                            Timer(const Duration(seconds: 4), () {
                              controller.isNotValue();
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 3,
                              color: Colors.white,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(
                                50,
                              ),
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(2, 4),
                                color: Colors.black.withOpacity(
                                  0.3,
                                ),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Icon(
                              Icons.add_a_photo,
                              color: ColorConstraint.primaryLightColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Spaces.large,
              StreamBuilder<DocumentSnapshot>(
                stream: personalData,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                      width: Get.width,
                      child: Column(
                        children: [
                          Spaces.largeh,
                          Spaces.largeh,
                          customTextWidget(
                            snapshot.data!['email'],
                            _themeController.isDarkMode.value
                                ? ColorConstraint().primaryColor
                                : ColorConstraint().secondaryColor,
                            FontWeight.w800,
                            21,
                          ),
                          Spaces.largeh,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              customTextWidget(
                                snapshot.data!['name'],
                                _themeController.isDarkMode.value
                                    ? ColorConstraint().primaryColor
                                    : ColorConstraint.primaryLightColor,
                                FontWeight.w800,
                                21,
                              ),
                              IconButton(
                                onPressed: () {
                                  showBottomInfoProfile(
                                    context,
                                    snapshot.data!['name'],
                                  );
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: _themeController.isDarkMode.value
                                      ? ColorConstraint().primaryColor
                                      : ColorConstraint.primaryLightColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  return const CircularProgressIndicator();
                },
              ),
              const SizedBox(
                height: 70,
              ),
              customTrackContainer(context),
            ],
          ),
        ),
      ),
    );
  }
}
