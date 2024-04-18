import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seeker_app/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserProfile _userProfile;

  UserProvider()
      : _userProfile = UserProfile(
          uid: '',
          email: '',
          firstName: '',
          lastName: '',
          dateNaissance: '',
          biography: '',
          photoUrl: '',
        );

  UserProfile get userProfile => _userProfile;

  void setUserProfile(UserProfile userProfile) {
    _userProfile = userProfile;
    notifyListeners();
  }

  Future<void> loadUserProfile(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        print("Document récupéré : ${userDoc.data()}");
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        setUserProfile(UserProfile(
          uid: uid,
          email: userData['email'] ?? '',
          firstName: userData['firstName'] ?? '',
          lastName: userData['lastName'] ?? '',
          dateNaissance: userData['dateNaissance'] ?? '',
          biography: userData['biography'] ?? '',
          photoUrl: userData['photoUrl'] ?? '',
        ));
      } else {
        print("Aucun document trouvé pour l'uid : $uid");
      }
    } catch (e) {
      print("Erreur lors du chargement du profil utilisateur: $e");
      // Gérer l'erreur ou mettre à jour l'UI pour refléter l'échec du chargement
    }
  }
}
