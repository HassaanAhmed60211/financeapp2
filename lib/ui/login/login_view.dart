import 'package:finance_track_app/core/utils.dart';
import 'package:finance_track_app/core/widgets/custom_elevated.dart';
import 'package:finance_track_app/core/widgets/spaces_widget.dart';
import 'package:finance_track_app/core/widgets/text_widgets.dart';
import 'package:finance_track_app/core/widgets/textfield_widget.dart';
import 'package:finance_track_app/ui/login/widget/login_controller.dart';
import 'package:finance_track_app/ui/signup/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class LoginView extends StatelessWidget {
  LoginView({super.key});
  LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: ColorConstraint.whiteColor,
        automaticallyImplyLeading: false,
        backgroundColor: ColorConstraint().primaryColor,
        centerTitle: true,
        title: customTextWidget(
            'Sign In', const Color(0xff1F2C37), FontWeight.w600, 18),
      ),
      backgroundColor: ColorConstraint().primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spaces.large,
              Spaces.smallh,
              Align(
                alignment: Alignment.topLeft,
                child: customTextWidget('Hi, Welcome Back! 👋',
                    ColorConstraint.secondaryColor, FontWeight.w700, 24),
              ),
              Spaces.smallh,
              Align(
                alignment: Alignment.topLeft,
                child: customTextWidget(
                    'Login and track your finance condition',
                    const Color(0xff78828A),
                    FontWeight.w400,
                    14),
              ),
              Spaces.large,
              Spaces.large,
              Align(
                alignment: Alignment.topLeft,
                child: customTextWidget('Email Address',
                    ColorConstraint.secondaryColor, FontWeight.w700, 14),
              ),
              Spaces.smallh,
              customTextField(controller.emailcontroller,
                  'Enter your email address', false),
              Spaces.mid,
              Align(
                alignment: Alignment.topLeft,
                child: customTextWidget('Password',
                    ColorConstraint.secondaryColor, FontWeight.w700, 14),
              ),
              Spaces.smallh,
              customTextField(
                  controller.passcontroller, 'Enter your password', true),
              Spaces.mid,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  customTextWidget("Don't have an account?",
                      ColorConstraint.secondaryColor, FontWeight.w500, 18),
                  Spaces.smallew,
                  GestureDetector(
                    onTap: () {
                      Get.to(SignupView());
                    },
                    child: customTextWidgetWithDecoration(
                        "Signup",
                        ColorConstraint.primeColor,
                        FontWeight.w800,
                        18,
                        TextDecoration.underline),
                  ),
                ],
              ),
              Spaces.large,
              customElevetedBtn(
                () {
                  if (controller.emailcontroller.text.isNotEmpty &&
                      controller.passcontroller.text.isNotEmpty) {
                    controller.userLogin(controller.emailcontroller.text,
                        controller.passcontroller.text, context);
                  } else {
                    var snackbar = const SnackBar(
                      content: Text("Fields is empty"),
                      backgroundColor: Colors.red,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  }
                },
                'Login',
                19,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
