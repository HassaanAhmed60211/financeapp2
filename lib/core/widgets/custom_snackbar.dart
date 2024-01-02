import 'package:finance_track_app/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
// import 'package:cleanng_app_oknomad1/utils/constants.dart';

showSuccessSnackBar(
    {String? label = "Success",
    msg,
    duration = 2,
    required BuildContext context}) {
  // var snackBar = SnackBar(
  //   content: customTextWidget(text: label!),
  //   duration: Duration(seconds: duration),
  //   backgroundColor: ColorConstants.successColor,
  // );

  // ScaffoldMessenger.of(context!).showSnackBar(snackBar);
  IconSnackBar.show(
    context: context,
    label: label ?? "Success",
    snackBarType: SnackBarType.save,
  );
}

showDangerSnackBar(
    {String? label = "Error",
    String? msg,
    int? duration = 2,
    required BuildContext context}) {
  // var snackBar = SnackBar(
  //   content: Text(
  //     label.toString() == "" ? "Error" : label.toString().capitalize(),
  //     style: const TextStyle(
  //       color: ColorConstants.whiteColor,
  //     ),
  //   ),
  //   duration: Duration(seconds: duration),
  //   backgroundColor: ColorConstants.dangerColor,
  // );

  // ScaffoldMessenger.of(context).showSnackBar(snackBar);
  IconSnackBar.show(
    context: context,
    label: label ?? "Error",
    snackBarType: SnackBarType.fail,
  );
}

showEmptyFieldsSnackBar(BuildContext context) {
  var snackBar = const SnackBar(
    content: Text(
      "Enter details!",
      style: TextStyle(
        color: ColorConstraint.whiteColor,
      ),
    ),
    backgroundColor: Colors.red,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
