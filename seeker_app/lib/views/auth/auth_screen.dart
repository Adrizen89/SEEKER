import 'package:flutter/material.dart';
import 'package:seeker_app/constants/colors.dart';
import 'package:seeker_app/constants/loaders.dart';
import 'package:seeker_app/constants/size.dart';
import 'package:seeker_app/helpers/validators.dart';
import 'package:seeker_app/models/user_model.dart';
import 'package:seeker_app/services/auth/auth_service.dart';
import 'package:seeker_app/services/image_selector.dart';
import 'package:seeker_app/views/settings/main_screen.dart';
import 'package:seeker_app/widgets/custom_buttons.dart';
import 'package:seeker_app/widgets/custom_text.dart';
import 'package:seeker_app/widgets/custom_textfield.dart';
import 'package:seeker_app/constants/assets.dart';
import 'dart:io';
import 'package:intl/intl.dart';

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

  final ImageSelector _imageSelector = ImageSelector();
  final _formKey = GlobalKey<FormState>();
  File? _image;
  TextEditingController dateInputController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _lastNameController.dispose();
    _firstNameController.dispose();
    _biographyController.dispose();
    dateInputController.dispose();
    super.dispose();
  }

  Future<void> _pickAndSetImage() async {
    final File? selectedImage = await _imageSelector.pickImage();
    setState(() {
      _image = selectedImage;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2050),
    );
    if (picked != null) {
      setState(() {
        dateInputController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
          padding: EdgeInsets.all(SizeConfig.customPadding()),
          child: Column(
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  if (_authFormType == AuthFormType.signIn)
                    ..._buildSignInForm(),
                  if (_authFormType == AuthFormType.signUp)
                    ..._buildSignUpForm(),
                  SizedBox(height: SizeConfig.customSizeBox()),
                  if (_authFormType == AuthFormType.signUpTwo)
                    ..._buildSignUpStepTwo(),
                  SizedBox(height: SizeConfig.customSizeBox()),
                ],
              ),
              _buildToggleButton(),
            ],
          )),
    ));
  }

  List<Widget> _buildSignInForm() {
    // Retourner ici les widgets du formulaire de connexion
    return [
      Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: SizeConfig.customSizeBox(),
              ),
              CustomTextField(
                labelText: 'Votre Email',
                hintText: 'Email',
                controller: _emailController,
                validator: validateEmail,
              ),
              SizedBox(height: SizeConfig.customSizeBox()),
              CustomTextField(
                labelText: 'Votre Mot de passe',
                hintText: 'Mot de passe',
                obscureText: true,
                controller: _passwordController,
                validator: validatePassword,
              ),
              SizedBox(height: SizeConfig.customSizeBox()),
              CustomTextClick(text: 'Mot de passe oublié ?'),
              SizedBox(height: SizeConfig.customSizeBox()),
              CustomButtonSecondary(
                  text: 'Se connecter',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      CustomLoaderSign.showLoadingDialog(context,
                          message: "Connexion en cours...");
                      try {
                        final user = await _authService.signIn(
                          context,
                          _emailController.text,
                          _passwordController.text,
                        );
                        if (user != null) {
                          print("Connexion réussie");
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => MainScreen()));
                        }
                      } catch (e) {
                        Navigator.of(context).pop();
                        print(e);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text("Erreur lors de la connexion : $e")),
                        );
                      }
                    }
                  }),
            ],
          ))
    ];
  }

  List<Widget> _buildSignUpForm() {
    // Retourner ici les widgets du formulaire d'inscription
    return [
      SizedBox(
        height: SizeConfig.customSizeBox(),
      ),
      CustomTextField(
        labelText: 'Votre Nom',
        hintText: 'Nom',
        controller: _lastNameController,
        validator: validateLastName,
      ),
      SizedBox(height: SizeConfig.customSizeBox()),
      CustomTextField(
        labelText: 'Votre Prénom',
        hintText: 'Prénom',
        controller: _firstNameController,
        validator: validateFirstName,
      ),
      SizedBox(height: SizeConfig.customSizeBox()),
      CustomTextField(
        labelText: 'Votre Date de naissance',
        hintText: 'Date de naissance',
        controller: dateInputController,
        onTap: () {
          _selectDate(context);
        },
      ),
      SizedBox(height: SizeConfig.customSizeBox()),
      CustomTextField(
        labelText: 'Votre Email',
        hintText: 'Email',
        controller: _emailController,
        validator: validateEmail,
      ),
      SizedBox(height: SizeConfig.customSizeBox()),
      CustomTextField(
        labelText: 'Votre Mot de passe',
        hintText: 'Mot de passe',
        obscureText: true,
        controller: _passwordController,
        validator: validatePassword,
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
      InkWell(
        onTap: _pickAndSetImage,
        child: CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey[300],
          backgroundImage: _image != null ? FileImage(_image!) : null,
          child: _image == null
              ? Icon(
                  Icons.add,
                  size: 50,
                  color: Colors.white,
                )
              : null,
        ),
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
          CustomLoaderSign.showLoadingDialog(context,
              message: "Inscription en cours...");
          DateFormat format = DateFormat("dd/MM/yyyy");
          DateTime? dateNaissance;

          try {
            dateNaissance = format.parse(dateInputController.text.trim());
          } catch (e) {
            print("Erreur de formatage de la date: $e");
            // Gérer l'erreur de formatage ici, par exemple en informant l'utilisateur
          }
          UserProfile newUserProfile = UserProfile(
              uid: '',
              email: _emailController.text.trim(),
              firstName: _firstNameController.text.trim(),
              lastName: _lastNameController.text.trim(),
              biography: _biographyController.text.trim(),
              dateNaissance: dateNaissance!,
              dateRegister: DateTime.now());
          try {
            await AuthService().signUp(
              profile: newUserProfile,
              password: _passwordController.text,
              image: _image,
            );
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => MainScreen()));
          } catch (e) {
            Navigator.of(context).pop();
            // Gestion de l'erreur
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Erreur lors de l'inscription: $e")),
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
