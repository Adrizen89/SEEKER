import 'package:flutter/material.dart';
import 'package:seeker_app/constants/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final IconData? icon;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final bool? readOnly;
  final void Function()? onTap;

  const CustomTextField({
    Key? key,
    this.controller,
    this.hintText,
    this.labelText,
    this.keyboardType,
    this.textInputAction = TextInputAction.done,
    this.obscureText = false,
    this.icon,
    this.validator,
    this.onFieldSubmitted,
    this.readOnly,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: ColorSelect.normalFieldColor,
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: TextFormField(
        keyboardType: keyboardType,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: ColorSelect.mainColor.withOpacity(0.5)),
          labelText: labelText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
        obscureText: obscureText,
        validator: validator,
        readOnly: readOnly!,
        onTap: onTap,
      ),
    );
  }
}
