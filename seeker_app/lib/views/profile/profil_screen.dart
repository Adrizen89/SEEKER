import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:seeker_app/constants/colors.dart';
import 'package:seeker_app/constants/size.dart';
import 'package:seeker_app/providers/user_data_provider.dart';
import 'package:seeker_app/widgets/custom_text.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProvider>(context).userProfile;

    return Scaffold(
        body: Column(children: [
      Container(
          height: SizeConfig.screenHeight * 0.48,
          width: SizeConfig.screenWidth * 1,
          color: ColorSelect.mainColor,
          child: Padding(
            padding: EdgeInsets.only(
                right: SizeConfig.customPadding(),
                left: SizeConfig.customPadding()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: ColorSelect.secondaryColor,
                      radius: SizeConfig.screenWidth * 0.15,
                      child: CircleAvatar(
                        radius: SizeConfig.screenWidth * 0.14,
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: ColorSelect.secondaryColor,
                      radius: SizeConfig.screenWidth * 0.07,
                      child: Icon(
                        Icons.pending,
                        color: ColorSelect.mainColor,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.02,
                ),
                CustomTitle(
                  color: ColorSelect.grey100,
                  title: "${userProfile.firstName} ${userProfile.lastName}",
                  fontsize: SizeConfig.customFontSizeTitle(),
                ),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.02,
                ),
                Text(
                  "${userProfile.biography}",
                  style: TextStyle(
                      fontSize: SizeConfig.customFontSizeText(),
                      color: ColorSelect.grey100),
                ),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.03,
                ),
              ],
            ),
          )),
      Container(
          height: SizeConfig.screenHeight * 0.35,
          width: SizeConfig.screenWidth * 1,
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.only(
                top: SizeConfig.customPadding(),
                right: SizeConfig.customPadding(),
                left: SizeConfig.customPadding()),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        child: Column(
                      children: [
                        CustomTitle(
                          color: ColorSelect.mainColor,
                          title: '67',
                          fontsize: SizeConfig.customFontSizeTitle(),
                        ),
                        Text(
                          'dévouvertes',
                          style: TextStyle(
                              fontSize: SizeConfig.customFontSizeText(),
                              color: ColorSelect.mainColor),
                        )
                      ],
                    )),
                    Container(
                        child: Column(
                      children: [
                        Text(
                          'inscrit le',
                          style: TextStyle(
                              fontSize: SizeConfig.customFontSizeText(),
                              color: ColorSelect.mainColor),
                        ),
                        CustomTitle(
                            color: ColorSelect.mainColor,
                            title: '27/08/2023',
                            fontsize: SizeConfig.customFontSizeTitle()),
                      ],
                    ))
                  ],
                ),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.03,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: ColorSelect.mainColor.withOpacity(0.5)))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTitle(
                        color: ColorSelect.mainColor,
                        title: "Informations Personnelles",
                        fontsize: SizeConfig.screenWidth * 0.035,
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.arrow_downward,
                            color: ColorSelect.mainColor,
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.02,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: ColorSelect.mainColor.withOpacity(0.5)))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTitle(
                        color: ColorSelect.mainColor,
                        title: "Préférences de l'application",
                        fontsize: SizeConfig.screenWidth * 0.035,
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.arrow_downward,
                            color: ColorSelect.mainColor,
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.02,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: ColorSelect.mainColor.withOpacity(0.5)))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTitle(
                        color: ColorSelect.mainColor,
                        title: "Paramètres de sécurité & confidentialité",
                        fontsize: SizeConfig.screenWidth * 0.035,
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.arrow_downward,
                            color: ColorSelect.mainColor,
                          ))
                    ],
                  ),
                )
              ],
            ),
          ))
    ]));
  }
}
