import 'package:flutter/material.dart';
import 'package:seeker_app/constants/colors.dart';

class CustomButtonMain extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;

  const CustomButtonMain({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor = ColorSelect.grey100,
    this.fontSize = 16.0,
    this.padding = const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorSelect.mainButtonColor,
        foregroundColor: textColor,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: TextStyle(
          fontSize: fontSize,
        ),
      ),
      child: Text(text),
    );
  }
}

class CustomButtonSecondary extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;

  const CustomButtonSecondary({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor = ColorSelect.grey100,
    this.fontSize = 16.0,
    this.padding = const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorSelect.secondaryButtonColor,
        foregroundColor: textColor,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: TextStyle(
          fontSize: fontSize,
        ),
      ),
      child: Text(text),
    );
  }
}
