import 'package:finance_track_app/core/utils.dart';
import 'package:finance_track_app/core/widgets/app_bar.dart';
import 'package:finance_track_app/core/widgets/custom_elevated.dart';
import 'package:finance_track_app/core/widgets/spaces_widget.dart';
import 'package:finance_track_app/core/widgets/text_widgets.dart';
import 'package:finance_track_app/core/widgets/textfield_widget.dart';
import 'package:finance_track_app/ui/dashboard/dashboard_controller.dart';
import 'package:finance_track_app/ui/dashboard/dashboard_page.dart';
import 'package:finance_track_app/ui/login/login_view.dart';
import 'package:finance_track_app/ui/signup/widget/signup_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupView extends StatelessWidget {
  SignupView({super.key});
  SignupController controller = Get.put(SignupController());
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  DashboardController dashController = Get.put(DashboardController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstraint().primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: customTextWidget('SignUp',
                  ColorConstraint().secondaryColor, FontWeight.w700, 30),
            ),
            Spaces().midh(),
            customTextField(emailcontroller, 'Enter your email', false),
            Spaces().midh(),
            customTextField(namecontroller, 'Enter your name', false),
            Spaces().midh(),
            customTextField(passcontroller, 'Enter your password', true),
            Spaces().midh(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                customTextWidget("Already have an account?",
                    ColorConstraint().secondaryColor, FontWeight.w500, 18),
                Spaces().smallw(),
                GestureDetector(
                  onTap: () {
                    Get.to(LoginView());
                  },
                  child: customTextWidgetWithDecoration(
                      "Login",
                      ColorConstraint().secondaryColor,
                      FontWeight.w800,
                      18,
                      TextDecoration.underline),
                ),
              ],
            ),
            Spaces().largeh(),
            customElevetedBtn(() async {
              controller.userSignUp(emailcontroller.text, passcontroller.text,
                  namecontroller.text, context);

              emailcontroller.clear();
              passcontroller.clear();
              namecontroller.clear();
            }, 'Signup', 19),
          ],
        ),
      ),
    );
  }
}
