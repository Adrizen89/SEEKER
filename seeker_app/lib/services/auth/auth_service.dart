import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeker_app/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeker_app/providers/user_data_provider.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signUp({
    required UserProfile profile,
    required File? image,
    required String password,
  }) async {
    try {
      // Étape 1: Inscription de l'utilisateur
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: profile.email.trim(),
        password: password.trim(),
      );
      final User? user = userCredential.user;

      if (user != null) {
        String imageUrl = '';

        // Étape 2: Upload de l'image de profil (si sélectionnée)
        if (image != null) {
          final Reference storageRef = FirebaseStorage.instance
              .ref()
              .child('user_images/${user.uid}.jpg');
          final UploadTask uploadTask = storageRef.putFile(image);
          await uploadTask;
          imageUrl = await storageRef.getDownloadURL();
        }

        // Étape 3: Création du profil utilisateur
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': profile.email.trim(),
          'firstName': profile.firstName.trim(),
          'lastName': profile.lastName.trim(),
          'imageUrl': imageUrl,
          'dateNaissance': profile.dateNaissance,
          'dateRegister': DateTime.now(),
          'biography': profile.biography,
        });

        print('Utilisateur inscrit avec succès.');
      }
    } catch (e) {
      print('Erreur lors de l\'inscription: $e');
      throw e; // Vous pouvez choisir de gérer l'erreur différemment
    }
  }

  Future<User?> signIn(
      BuildContext context, String email, String password) async {
    FirebaseAuth _auth = FirebaseAuth
        .instance; // Assurez-vous que _auth est initialisé si ce n'est pas déjà fait ici

    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        // L'utilisateur est connecté, charger son profil
        await Provider.of<UserProvider>(context, listen: false)
            .loadUserProfile(user.uid);
        // Vous pouvez ici naviguer vers la page d'accueil ou effectuer d'autres actions
      }

      return user;
    } catch (error) {
      print(error);
      // Gérer l'erreur de connexion
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email, BuildContext context) async {
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Veuillez entrer votre email pour réinitialiser votre mot de passe.")),
      );
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Un email de réinitialisation de mot de passe a été envoyé.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Erreur lors de l'envoi de l'email. Vérifiez l'email et réessayez.")),
      );
    }
  }

  Future<void> updateEmail(BuildContext context, String newEmail) async {
    if (newEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("L'email ne peut pas être vide.")));
      return;
    }
    try {
      await FirebaseAuth.instance.currentUser!.updateEmail(newEmail);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email mis à jour avec succès.")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Erreur lors de la mise à jour de l'email : $e")));
    }
  }

  Exception _handleFirebaseAuthException(FirebaseAuthException e) {
    if (e.code == 'weak-password') {
      return Exception('Le mot de passe fourni est trop faible.');
    } else if (e.code == 'email-already-in-use') {
      return Exception('Un compte existe déjà avec cet email.');
    } else {
      return Exception('Erreur d\'authentification Firebase: ${e.message}');
    }
  }
}
