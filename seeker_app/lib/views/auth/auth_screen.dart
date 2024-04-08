import 'package:flutter/material.dart';
import 'package:seeker_app/constants/colors.dart';
import 'package:seeker_app/constants/size.dart';
import 'package:seeker_app/models/user_model.dart';
import 'package:seeker_app/services/auth/auth_service.dart';
import 'package:seeker_app/widgets/custom_buttons.dart';
import 'package:seeker_app/widgets/custom_pickImage.dart';
import 'package:seeker_app/widgets/custom_text.dart';
import 'package:seeker_app/widgets/custom_textfield.dart';
import 'package:seeker_app/constants/assets.dart';
import 'dart:io';

enum AuthFormType { signIn, signUp, signUpTwo }

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService _authService = AuthService();
  AuthFormType _authFormType = AuthFormType.signIn;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _biographyController = TextEditingController();
  File? _selectedImageFile;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _lastNameController.dispose();
    _firstNameController.dispose();
    _biographyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(SizeConfig.customPadding()),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(child: Image.asset(Assets.logoFull)),
              _authFormType == AuthFormType.signUpTwo
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                _authFormType = AuthFormType.signUp;
                              });
                            },
                            icon: Icon(Icons.arrow_back_ios)),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.15,
                        ),
                        CustomTitle(
                            fontsize: SizeConfig.customFontSizeTitle(),
                            color: ColorSelect.secondaryColor,
                            title: 'S\'inscrire'),
                      ],
                    )
                  : CustomTitle(
                      fontsize: SizeConfig.customFontSizeTitle(),
                      color: ColorSelect.secondaryColor,
                      title: _authFormType == AuthFormType.signIn
                          ? 'Se connecter'
                          : 'S\'inscrire'),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (_authFormType == AuthFormType.signIn)
                    ..._buildSignInForm(),
                  if (_authFormType == AuthFormType.signUp)
                    ..._buildSignUpForm(),
                  SizedBox(height: SizeConfig.customSizeBox()),
                  if (_authFormType ==
                      AuthFormType
                          .signUpTwo) // Hypothétique cas pour l'étape deux
                    ..._buildSignUpStepTwo(),
                  SizedBox(height: SizeConfig.customSizeBox()),
                ],
              ),
              _buildToggleButton(),
            ],
          )),
    );
  }

  List<Widget> _buildSignInForm() {
    // Retourner ici les widgets du formulaire de connexion
    return [
      CustomTextField(
        hintText: 'Email',
        controller: _emailController,
      ),
      SizedBox(height: SizeConfig.customSizeBox()),
      CustomTextField(
        hintText: 'Mot de passe',
        obscureText: true,
        controller: _passwordController,
      ),
      SizedBox(height: SizeConfig.customSizeBox()),
      CustomTextClick(text: 'Mot de passe oublié ?'),
      SizedBox(height: SizeConfig.customSizeBox()),
      CustomButtonSecondary(
          text: 'Se connecter',
          onPressed: () async {
            try {
              final user = await _authService.signIn(
                // Assurez-vous d'avoir des TextEditingController pour récupérer ces valeurs
                _emailController.text,
                _passwordController.text,
              );
              if (user != null) {
                print("Connexion réussie");
                // Naviguez vers votre écran d'accueil ou autre
              }
            } catch (e) {
              print(e);
              // Affichez une erreur à l'utilisateur
            }
          }),
    ];
  }

  List<Widget> _buildSignUpForm() {
    // Retourner ici les widgets du formulaire d'inscription
    return [
      CustomTextField(
        hintText: 'Nom',
        controller: _lastNameController,
      ),
      SizedBox(height: SizeConfig.customSizeBox()),
      CustomTextField(
        hintText: 'Prénom',
        controller: _firstNameController,
      ),
      SizedBox(height: SizeConfig.customSizeBox()),
      CustomTextField(hintText: 'Date de naissance'),
      SizedBox(height: SizeConfig.customSizeBox()),
      CustomTextField(
        hintText: 'Email',
        controller: _emailController,
      ),
      SizedBox(height: SizeConfig.customSizeBox()),
      CustomTextField(
        hintText: 'Mot de passe',
        obscureText: true,
        controller: _passwordController,
      ),
      SizedBox(height: SizeConfig.customSizeBox()),
      CustomButtonSecondary(
        text: 'Je m\'inscris',
        onPressed: () {
          setState(() {
            _authFormType = AuthFormType.signUpTwo;
          });
        },
      ),
    ];
  }

  List<Widget> _buildSignUpStepTwo() {
    return [
      // Ajoutez vos champs de formulaire pour l'étape deux ici

      ImagePickerCircle(
        onImageSelected: (File selectedImage) {
          // Stockez l'image sélectionnée dans une variable d'état du widget parent
          setState(() {
            _selectedImageFile = selectedImage;
          });
          print("Fichier sélectionné : ${_selectedImageFile}");
        },
      ),

      SizedBox(height: SizeConfig.customSizeBox()),

      CustomTextField(
        hintText: 'Biographie',
        controller: _biographyController,
      ),

      SizedBox(height: SizeConfig.customSizeBox()),
      // Bouton pour finaliser l'inscription
      CustomButtonSecondary(
        text: 'Terminé',
        onPressed: () async {
          if (_emailController.text.isEmpty ||
              _passwordController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Email et mot de passe sont requis")),
            );
            return;
          }

          try {
            // Étape 1: Inscription de l'utilisateur
            final user = await _authService.signUp(
              _emailController.text.trim(),
              _passwordController.text.trim(),
            );

            if (user != null) {
              String imageUrl = '';

              // Étape 2: Upload de l'image de profil (si sélectionnée)
              if (_selectedImageFile != null) {
                print("Fichier sélectionné : ${_selectedImageFile}");
                imageUrl = await _authService.uploadUserImage(
                    _selectedImageFile!, user.uid);
                print("URL de l'image : $imageUrl");
              } else {
                print("Aucun fichier d'image sélectionné.");
              }

              // Étape 3: Création du profil utilisateur
              UserProfile newUserProfile = UserProfile(
                uid: user.uid,
                email: user.email!,
                firstName: _firstNameController.text.trim(),
                lastName: _lastNameController.text.trim(),
                photoUrl:
                    imageUrl, // sera vide si aucune image n'a été téléchargée
                biography: _biographyController.text.trim(),
              );

              await _authService.createUserProfile(newUserProfile);

              // Navigation vers l'écran d'accueil ou un écran de succès
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) =>
                      AuthScreen())); // Assurez-vous d'avoir un HomeScreen.
            }
          } catch (e) {
            // Gestion de l'erreur
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString())),
            );
          }
        },
      ),
    ];
  }

  Widget _buildToggleButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          _authFormType = _authFormType == AuthFormType.signIn
              ? AuthFormType.signUp
              : AuthFormType.signIn;
        });
      },
      child: CustomTextClick(
        text: _authFormType == AuthFormType.signIn
            ? 'Pas de compte ? S\'inscrire'
            : 'Déjà inscrit ? Se connecter',
      ),
    );
  }
}
