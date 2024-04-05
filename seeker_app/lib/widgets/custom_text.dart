import 'package:flutter/material.dart';
import 'package:seeker_app/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextClick extends StatelessWidget {
  final String text;
  final double? fontsize;

  const CustomTextClick({super.key, required this.text, this.fontsize});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text(
        text,
        style: TextStyle(
            decoration: TextDecoration.underline,
            color: ColorSelect.textClickColor,
            fontSize: fontsize,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}

class CustomTitle extends StatelessWidget {
  final String title;
  final double? fontsize;
  final Color? color;

  const CustomTitle(
      {super.key, required this.title, this.fontsize, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.montserrat(
          fontSize: fontsize, color: color, fontWeight: FontWeight.w700),
    );
  }
}
