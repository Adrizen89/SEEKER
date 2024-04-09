import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeker_app/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

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
        });

        print('Utilisateur inscrit avec succès.');
      }
    } catch (e) {
      print('Erreur lors de l\'inscription: $e');
      throw e; // Vous pouvez choisir de gérer l'erreur différemment
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
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
