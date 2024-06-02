import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

textView(String text, double fontSize, Color fontColor, FontWeight fontBold,
    TextAlign positionFont, EdgeInsets margin) {
  return Container(
    margin: margin,
    child: Text(
      text,
      textAlign: positionFont,
      style: GoogleFonts.poppins(
        color: fontColor,
        fontWeight: fontBold,
        fontSize: fontSize,
      ),
    ),
  );
}

textButtonBox(String text, double textSize, double height, double roundedBox,
    Color warnaBox, onTap) {
  return Container(
    height: height,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(roundedBox), color: warnaBox),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(roundedBox),
        onTap: onTap,
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: textSize,
            ),
          ),
        ),
      ),
    ),
  );
}


