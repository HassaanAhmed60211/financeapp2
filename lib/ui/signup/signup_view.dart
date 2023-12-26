import 'package:finance_track_app/core/utils.dart';
import 'package:finance_track_app/core/widgets/custom_elevated.dart';
import 'package:finance_track_app/core/widgets/spaces_widget.dart';
import 'package:finance_track_app/core/widgets/text_widgets.dart';
import 'package:finance_track_app/core/widgets/textfield_widget.dart';
import 'package:finance_track_app/ui/dashboard/dashboard_controller.dart';
import 'package:finance_track_app/ui/login/login_view.dart';
import 'package:finance_track_app/ui/signup/widget/signup_controller.dart';
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
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: ColorConstraint.secondaryColor, //change your color here
        ),
        backgroundColor: ColorConstraint().primaryColor,
        centerTitle: true,
        title: customTextWidget(
            'Sign Up', const Color(0xff1F2C37), FontWeight.w600, 18),
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
                child: customTextWidget('Create Account',
                    ColorConstraint.secondaryColor, FontWeight.w700, 24),
              ),
              Spaces.smallh,
              Align(
                alignment: Alignment.topLeft,
                child: customTextWidget(
                    'Registered and track your finance condition',
                    const Color(0xff78828A),
                    FontWeight.w400,
                    14),
              ),
              Spaces.large,
              Spaces.large,
              Align(
                alignment: Alignment.topLeft,
                child: customTextWidget('Full Name',
                    ColorConstraint.secondaryColor, FontWeight.w700, 14),
              ),
              Spaces.smallh,
              customTextField(namecontroller, 'Enter your name', false),
              Spaces.mid,
              Align(
                alignment: Alignment.topLeft,
                child: customTextWidget('Email Address',
                    ColorConstraint.secondaryColor, FontWeight.w700, 14),
              ),
              Spaces.smallh,
              customTextField(
                  emailcontroller, 'Enter your email address', false),
              Spaces.mid,
              Align(
                alignment: Alignment.topLeft,
                child: customTextWidget('Password',
                    ColorConstraint.secondaryColor, FontWeight.w700, 14),
              ),
              Spaces.smallh,
              customTextField(passcontroller, 'Enter your password', false),
              Spaces.mid,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  customTextWidget("Already have an account?",
                      ColorConstraint.secondaryColor, FontWeight.w500, 18),
                  Spaces.smallew,
                  GestureDetector(
                    onTap: () {
                      Get.to(LoginView());
                    },
                    child: customTextWidgetWithDecoration(
                        "Login",
                        const Color(0xff4F3D56),
                        FontWeight.w800,
                        18,
                        TextDecoration.underline),
                  ),
                ],
              ),
              Spaces.large,
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
      ),
    );
  }
}
