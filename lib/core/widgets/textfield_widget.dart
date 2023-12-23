import 'package:flutter/material.dart';

Widget customTextField(controller, hinttext, bool? value) {
  return TextFormField(
    controller: controller,
    style: const TextStyle(color: Colors.black),
    obscureText: value ?? false,
    decoration: InputDecoration(
      hintText: hinttext,
      hintStyle:
          TextStyle(color: Color(0xff78828A), fontWeight: FontWeight.w400),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xffECF1F6))),
      focusedBorder:
          OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
    ),
  );
}
