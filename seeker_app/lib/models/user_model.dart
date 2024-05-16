class UserProfile {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final DateTime dateNaissance;
  final String? imageUrl;
  final String biography;
  final DateTime dateRegister;

  UserProfile({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.dateNaissance,
    this.imageUrl,
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
      'imageUrl': imageUrl,
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
    String? imageUrl,
    String? biography,
    DateTime? dateRegister,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateNaissance: dateNaissance ?? this.dateNaissance,
      imageUrl: imageUrl ?? this.imageUrl,
      biography: biography ?? this.biography,
      dateRegister: dateRegister ?? this.dateRegister,
    );
  }
}
