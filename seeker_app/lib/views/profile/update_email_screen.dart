import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateEmailScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modifier l'Email"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Nouvel Email",
                hintText: "Entrez votre nouvel email",
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => updateEmail(context),
              child: Text("Mettre à jour l'Email"),
            ),
          ],
        ),
      ),
    );
  }

  void updateEmail(BuildContext context) async {
    try {
      String newEmail = emailController.text.trim();
      await FirebaseAuth.instance.currentUser!
          .verifyBeforeUpdateEmail(newEmail);
      Navigator.of(context).pop(); // Optionally pop the screen
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email mis à jour avec succès.")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Erreur lors de la mise à jour de l'email : $e")));
    }
  }
}
