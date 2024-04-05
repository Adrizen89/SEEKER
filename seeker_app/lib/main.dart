import 'package:flutter/material.dart';
import 'package:seeker_app/widgets/custom_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Seeker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Scaffold(
            body: Center(
                child: CustomTextClick(
                    onPressed: () {}, text: 'Mot de passe Oublié ?'))));
  }
}
