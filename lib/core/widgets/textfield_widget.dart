import 'package:flutter/material.dart';

Widget customTextField(controller, hinttext, bool? value) {
  return TextFormField(
    controller: controller,
    style: TextStyle(color: Colors.black),
    obscureText: value ?? false,
    decoration: InputDecoration(
      hintText: hinttext,
      enabledBorder:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
