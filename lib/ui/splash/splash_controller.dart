import 'dart:async';

import 'package:finance_track_app/ui/boarding%20screen/boarding_screen.dart';
import 'package:finance_track_app/ui/login/login_view.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Timer(const Duration(seconds: 3), () {
      Get.to(() => const BoardingScreen());
    });
  }
}
