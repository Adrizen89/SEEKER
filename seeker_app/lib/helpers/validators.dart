String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'L\'email ne peut pas être vide';
  }
  String pattern = r'\w+@\w+\.\w+';
  if (!RegExp(pattern).hasMatch(value)) {
    return 'Entrez un email valide';
  }
  return null; // Retourne null si la valeur est valide
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Le mot de passe ne peut pas être vide';
  }
  if (value.length < 8) {
    return 'Le mot de passe doit contenir au moins 8 caractères';
  }
  return null;
}

String? validateLastName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Veuillez renseigner votre nom !';
  }
  return null;
}

String? validateFirstName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Veuillez renseigner votre prénom !';
  }
  return null;
}
