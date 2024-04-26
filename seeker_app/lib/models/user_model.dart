class UserProfile {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final DateTime dateNaissance;
  final String? photoUrl;
  final String biography;
  final DateTime dateRegister;

  UserProfile({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.dateNaissance,
    this.photoUrl,
    required this.biography,
    required this.dateRegister,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'dateNaissance': dateNaissance,
      'photoUrl': photoUrl,
      'biography': biography,
      'dateRegister': DateTime.now()
    };
  }

  UserProfile copyWith({
    String? uid,
    String? email,
    String? firstName,
    String? lastName,
    DateTime? dateNaissance,
    String? photoUrl,
    String? biography,
    DateTime? dateRegister,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateNaissance: dateNaissance ?? this.dateNaissance,
      photoUrl: photoUrl ?? this.photoUrl,
      biography: biography ?? this.biography,
      dateRegister: dateRegister ?? this.dateRegister,
    );
  }
}
