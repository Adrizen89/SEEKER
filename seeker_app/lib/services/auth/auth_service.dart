import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeker_app/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _firebaseFirestore = FirebaseFirestore.instance;

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      // Gérer l'exception
      throw _handleFirebaseAuthException(e);
    }
  }

  Future<String> uploadUserImage(File imageFile, String userId) async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child('user_images/$userId.jpg');

    UploadTask uploadTask = storageReference.putFile(imageFile);
    await uploadTask;

    // Une fois le téléchargement terminé, récupérez et retournez l'URL de l'image.
    String downloadUrl = await storageReference.getDownloadURL();
    return downloadUrl;
  }

  Future<void> createUserProfile(UserProfile profile) async {
    await _firebaseFirestore
        .collection('users')
        .doc(profile.uid)
        .set(profile.toMap());
  }

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
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
    await _firebaseAuth.signOut();
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
