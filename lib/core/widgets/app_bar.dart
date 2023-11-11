import 'package:finance_track_app/core/utils.dart';
import 'package:flutter/material.dart';

Widget GlobalAppBar(title, leadingOntap, actionOntap) {
  return AppBar(
    leading: IconButton(
        onPressed: leadingOntap,
        icon: Icon(
          Icons.menu,
          color: ColorConstraint().secondaryColor,
          size: 19,
        )),
    title: title,
    automaticallyImplyLeading: false,
    actions: [
      IconButton(
          onPressed: actionOntap,
          icon: Icon(
            Icons.logout,
            color: ColorConstraint().secondaryColor,
            size: 19,
          )),
    ],
  );
}
