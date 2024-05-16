import 'package:flutter/material.dart';
import 'package:seeker_app/constants/colors.dart';
import 'package:seeker_app/constants/size.dart';
import 'package:seeker_app/providers/them_provider.dart';
import 'package:seeker_app/services/auth/auth_service.dart';
import 'package:seeker_app/views/profile/update_email_screen.dart';
import 'package:seeker_app/widgets/custom_alert_dialog.dart';
import 'package:seeker_app/widgets/custom_text.dart';
import 'package:provider/provider.dart';

// SECTION INFORMATIONS PERSONNELLES
class SectionInfosPersos extends StatefulWidget {
  final String name;
  final String email;
  final String dateNaissance;
  const SectionInfosPersos(
      {super.key,
      required this.name,
      required this.email,
      required this.dateNaissance});

  @override
  State<SectionInfosPersos> createState() => _SectionInfosPersosState();
}

class _SectionInfosPersosState extends State<SectionInfosPersos> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.customPadding(),
          right: SizeConfig.customPadding(),
          top: SizeConfig.customPadding()),
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom:
                    BorderSide(color: ColorSelect.mainColor.withOpacity(0.5)))),
        child: Column(
          children: [
            ListTile(
              title: CustomTitle(
                color: ColorSelect.mainColor,
                title: "Informations Personnelles",
                fontsize: SizeConfig.screenWidth * 0.035,
              ),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                icon: Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: ColorSelect.mainColor,
                ),
              ),
            ),
            Visibility(
                visible: isExpanded,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: SizeConfig.customPadding(),
                      right: SizeConfig.customPadding()),
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Nom / Prénom"),
                            CustomTitle(
                              title: widget.name,
                              color: ColorSelect.mainColor,
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.01),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Email"),
                            CustomTitle(
                                title: widget.email,
                                color: ColorSelect.mainColor)
                          ],
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.01),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Date de naissance"),
                            CustomTitle(
                                title: widget.dateNaissance,
                                color: ColorSelect.mainColor)
                          ],
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.01),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

// SECTION PREFERENCE APPLICATION
class SectionPrefApp extends StatefulWidget {
  const SectionPrefApp({super.key});

  @override
  State<SectionPrefApp> createState() => _SectionPrefAppState();
}

class _SectionPrefAppState extends State<SectionPrefApp> {
  bool isExpanded = false;
  bool isSwitchedNotif = false;
  bool isSwitchedMode = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.customPadding(),
          right: SizeConfig.customPadding(),
          top: SizeConfig.customPadding()),
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom:
                    BorderSide(color: ColorSelect.mainColor.withOpacity(0.5)))),
        child: Column(
          children: [
            ListTile(
              title: CustomTitle(
                color: ColorSelect.mainColor,
                title: "Préférence de l'application",
                fontsize: SizeConfig.screenWidth * 0.035,
              ),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                icon: Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: ColorSelect.mainColor,
                ),
              ),
            ),
            Visibility(
                visible: isExpanded,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: SizeConfig.customPadding(),
                      right: SizeConfig.customPadding()),
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Activer les notifications"),
                            Switch(
                              value: themeProvider.notificationsEnabled,
                              onChanged: (bool value) {
                                themeProvider.toggleNotifications();
                              },
                              activeTrackColor: ColorSelect.secondaryColor,
                              activeColor: ColorSelect.mainColor,
                              inactiveThumbColor: ColorSelect.mainColor,
                              inactiveTrackColor: ColorSelect.grey200,
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.01),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Mode Sombre"),
                            Switch(
                              value: themeProvider.darkMode,
                              onChanged: (bool value) {
                                themeProvider.toggleDarkMode();
                              },
                              activeTrackColor: ColorSelect.secondaryColor,
                              activeColor: ColorSelect.mainColor,
                              inactiveThumbColor: ColorSelect.mainColor,
                              inactiveTrackColor: ColorSelect.grey200,
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.01),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class SectionParamsSecuConf extends StatefulWidget {
  const SectionParamsSecuConf({super.key});

  @override
  State<SectionParamsSecuConf> createState() => _SectionParamsSecuConfState();
}

class _SectionParamsSecuConfState extends State<SectionParamsSecuConf> {
  final AuthService _authService = AuthService();
  bool isExpanded = false;
  bool? isSwitched;
  final TextEditingController _emailController = TextEditingController();

  void _showResetPasswordDialog(BuildContext context) {
    TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Réinitialiser le mot de passe"),
          content: TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: "Email",
              hintText: "Entrez votre email",
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Annuler"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Envoyer"),
              onPressed: () {
                _authService.resetPassword(
                    emailController.text.trim(), context);
                Navigator.of(context)
                    .pop(); // Fermer la boîte de dialogue après l'envoi
              },
            ),
          ],
        );
      },
    );
  }

  void showEmailUpdateDialog(
      BuildContext context, TextEditingController _emailController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogBox(
          title: "Modifier l'email",
          content: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "Entrez votre nouvel email",
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
          actions: [
            TextButton(
              child: Text("Annuler"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Modifier"),
              onPressed: () {
                _authService.updateEmail(context, _emailController.text.trim());
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.customPadding(),
          right: SizeConfig.customPadding(),
          top: SizeConfig.customPadding()),
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom:
                    BorderSide(color: ColorSelect.mainColor.withOpacity(0.5)))),
        child: Column(
          children: [
            ListTile(
              title: CustomTitle(
                color: ColorSelect.mainColor,
                title: "Paramètres de sécurité & confidentialité",
                fontsize: SizeConfig.screenWidth * 0.035,
              ),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                icon: Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: ColorSelect.mainColor,
                ),
              ),
            ),
            Visibility(
                visible: isExpanded,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: SizeConfig.customPadding(),
                      right: SizeConfig.customPadding()),
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Text("Changer mot de passe"),
                            ),
                            Text('***********')
                          ],
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.01),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => UpdateEmailScreen()));
                              },
                              child: Text("Changer email"),
                            ),
                            Text('adrien@gmail.com')
                          ],
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.01),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Politique de confidentialité des données"),
                          ],
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.01),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
