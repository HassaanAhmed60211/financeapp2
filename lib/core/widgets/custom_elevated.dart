import 'package:finance_track_app/core/utils.dart';
import 'package:finance_track_app/core/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget customElevetedBtn(onpressed, text, double? fontsize) {
  return SizedBox(
    width: Get.width,
    height: 50,
    child: ElevatedButton(
        style: TextButton.styleFrom(backgroundColor: const Color(0xff4F3D56)),
        onPressed: onpressed,
        child: customTextWidget(
            text, ColorConstraint().primaryColor, FontWeight.w500, fontsize)),
  );
}
