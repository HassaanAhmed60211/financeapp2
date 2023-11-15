import 'package:finance_track_app/core/utils.dart';
import 'package:finance_track_app/core/widgets/app_bar.dart';
import 'package:finance_track_app/core/widgets/custom_elevated.dart';
import 'package:finance_track_app/core/widgets/spaces_widget.dart';
import 'package:finance_track_app/core/widgets/text_widgets.dart';
import 'package:finance_track_app/core/widgets/textfield_widget.dart';
import 'package:finance_track_app/ui/login/widget/login_controller.dart';
import 'package:finance_track_app/ui/signup/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});
  LoginController controller = Get.put(LoginController());
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
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
              child: customTextWidget('LOGIN', ColorConstraint().secondaryColor,
                  FontWeight.w700, 30),
            ),
            Spaces().midh(),
            customTextField(emailcontroller, 'Enter your email', false),
            Spaces().midh(),
            customTextField(passcontroller, 'Enter your password', true),
            Spaces().midh(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                customTextWidget("Don't have an account?",
                    ColorConstraint().secondaryColor, FontWeight.w500, 18),
                Spaces().smallw(),
                GestureDetector(
                  onTap: () {
                    Get.to(SignupView());
                  },
                  child: customTextWidgetWithDecoration(
                      "Signup",
                      ColorConstraint().secondaryColor,
                      FontWeight.w800,
                      18,
                      TextDecoration.underline),
                ),
              ],
            ),
            Spaces().largeh(),
            customElevetedBtn(
              () {
                controller.userLogin(
                    emailcontroller.text, passcontroller.text, context);
              },
              'Login',
              19,
            ),
          ],
        ),
      ),
    );
  }
}
