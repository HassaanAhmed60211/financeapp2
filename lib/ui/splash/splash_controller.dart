import 'dart:async';

import 'package:finance_track_app/ui/login/login_view.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Timer(Duration(seconds: 3), () {
      Get.to(() => LoginView());
    });
  }
}
