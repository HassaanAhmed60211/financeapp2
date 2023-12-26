import 'package:finance_track_app/ui/splash/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  SplashController controller = Get.put(SplashController());
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color(0xff201937)),
      height: Get.height,
      width: Get.width,
      child: SvgPicture.asset(
        'assets/svg/splash_screen.svg',
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
