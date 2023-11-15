import 'package:finance_track_app/core/utils.dart';
import 'package:finance_track_app/core/widgets/text_widgets.dart';
import 'package:flutter/material.dart';

Widget customElevetedBtn(onpressed, text,double? fontsize) {
  return ElevatedButton(
      style: TextButton.styleFrom(backgroundColor: ColorConstraint().backColor),
      onPressed: onpressed,
      child: customTextWidget(
          text, ColorConstraint().primaryColor, FontWeight.w500, fontsize));
}
