import 'package:flutter/material.dart';
import 'package:seeker_app/constants/colors.dart';
import 'package:seeker_app/constants/size.dart';
import 'package:seeker_app/widgets/custom_buttons.dart';
import 'package:seeker_app/widgets/custom_pickImage.dart';
import 'package:seeker_app/widgets/custom_text.dart';
import 'package:seeker_app/widgets/custom_textfield.dart';
import 'package:seeker_app/constants/assets.dart';

enum AuthFormType { signIn, signUp, signUpTwo }

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthFormType _authFormType = AuthFormType.signIn;

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
      CustomTextField(hintText: 'Email'),
      SizedBox(height: SizeConfig.customSizeBox()),
      CustomTextField(hintText: 'Mot de passe', obscureText: true),
      SizedBox(height: SizeConfig.customSizeBox()),
      CustomTextClick(text: 'Mot de passe oublié ?'),
      SizedBox(height: SizeConfig.customSizeBox()),
      CustomButtonSecondary(text: 'Se connecter', onPressed: () {}),
    ];
  }

  List<Widget> _buildSignUpForm() {
    // Retourner ici les widgets du formulaire d'inscription
    return [
      CustomTextField(hintText: 'Nom'),
      SizedBox(height: SizeConfig.customSizeBox()),
      CustomTextField(hintText: 'Prénom'),
      SizedBox(height: SizeConfig.customSizeBox()),
      CustomTextField(hintText: 'Date de naissance'),
      SizedBox(height: SizeConfig.customSizeBox()),
      CustomTextField(hintText: 'Email'),
      SizedBox(height: SizeConfig.customSizeBox()),
      CustomTextField(hintText: 'Mot de passe', obscureText: true),
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

      ImagePickerCircle(),

      SizedBox(height: SizeConfig.customSizeBox()),

      CustomTextField(
        hintText: 'Biographie',
      ),

      SizedBox(height: SizeConfig.customSizeBox()),
      // Bouton pour finaliser l'inscription
      CustomButtonSecondary(
        text: 'Terminé',
        onPressed: () {
          // Logique pour finaliser l'inscription
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
