import 'package:flutter/material.dart';
import 'package:seeker_app/constants/colors.dart';
import 'package:seeker_app/constants/size.dart';
import 'package:seeker_app/widgets/custom_text.dart';

// SECTION INFORMATIONS PERSONNELLES
class SectionInfosPersos extends StatefulWidget {
  const SectionInfosPersos({super.key});

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
                              title: 'Adrien Berard',
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
                                title: 'adrien@gmail.com',
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
                                title: '27/08/2000',
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
                              value: isSwitchedNotif,
                              onChanged: (bool value) {
                                setState(() {
                                  isSwitchedNotif = value;
                                  print("Switch is now: $isSwitchedNotif");
                                });
                              },
                              activeTrackColor: ColorSelect.secondaryColor,
                              activeColor: ColorSelect.mainColor,
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
                              value: isSwitchedMode,
                              onChanged: (bool value) {
                                setState(() {
                                  isSwitchedMode = value;
                                  print("Switch is now: $isSwitchedMode");
                                });
                              },
                              activeTrackColor: ColorSelect.secondaryColor,
                              activeColor: ColorSelect.mainColor,
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
  bool isExpanded = false;
  bool? isSwitched;
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
                            Text("Changer mot de passe"),
                            Text('Adrien Berard')
                          ],
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.01),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Changer email"),
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
