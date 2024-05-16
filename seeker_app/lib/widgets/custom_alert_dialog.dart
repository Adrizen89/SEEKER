import 'package:flutter/material.dart';

class CustomDialogBox extends StatelessWidget {
  final String title;
  final List<Widget> content;
  final List<Widget> actions;

  const CustomDialogBox({
    Key? key,
    required this.title,
    required this.content,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: ListBody(
          children: content,
        ),
      ),
      actions: actions,
    );
  }
}
