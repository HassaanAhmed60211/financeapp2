import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget customTextWidget(
  String? text,
  Color? colortext,
  FontWeight? textfontweight,
  double? textfontsize,
) {
  return Text(
    text ?? '',
    style: TextStyle(
      color: colortext ?? Colors.black,
      fontWeight: textfontweight ?? FontWeight.w500,
      fontSize: textfontsize ?? 18,
      fontFamily: GoogleFonts.inter().fontFamily,
    ),
  );
}

Widget customTextWidgetWithDecoration(
  String? text,
  Color? colortext,
  FontWeight? textfontweight,
  double? textfontsize,
  TextDecoration? decoration,
) {
  return Text(
    text ?? '',
    style: TextStyle(
      color: colortext ?? Colors.black,
      fontWeight: textfontweight ?? FontWeight.w500,
      fontSize: textfontsize ?? 18,
      fontFamily: GoogleFonts.inter().fontFamily,
      decoration: decoration ?? TextDecoration.none,
      decorationColor: Color(0xff4F3D56),
    ),
  );
}
