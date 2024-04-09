class UserProfile {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String dateNaissance;
  final String? photoUrl;
  final String biography;

  UserProfile({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.dateNaissance,
    this.photoUrl,
    required this.biography,
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
    };
  }

  UserProfile copyWith({
    String? uid,
    String? email,
    String? firstName,
    String? lastName,
    String? dateNaissance,
    String? photoUrl,
    String? biography,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateNaissance: dateNaissance ?? this.dateNaissance,
      photoUrl: photoUrl ?? this.photoUrl,
      biography: biography ?? this.biography,
    );
  }
}
