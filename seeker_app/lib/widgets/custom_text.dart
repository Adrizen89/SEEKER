import 'package:flutter/material.dart';
import 'package:seeker_app/constants/colors.dart';

class CustomTextClick extends StatelessWidget {
  final String text;
  final double? fontsize;
  final VoidCallback onPressed;

  const CustomTextClick(
      {super.key, required this.text, required this.onPressed, this.fontsize});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
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
      style: TextStyle(
          fontSize: fontsize, color: color, fontWeight: FontWeight.bold),
    );
  }
}
