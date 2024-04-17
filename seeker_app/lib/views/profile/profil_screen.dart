import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:seeker_app/constants/colors.dart';
import 'package:seeker_app/constants/size.dart';
import 'package:seeker_app/models/user_model.dart';
import 'package:seeker_app/providers/user_data_provider.dart';
import 'package:seeker_app/widgets/custom_text.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  bool _isExpandedInfos = false;
  bool _isExpandedPrefs = false;
  bool _isExpandedSecurity = false;

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProvider>(context).userProfile;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildProfileHeader(userProfile),
            buildInformationSection(
                "Informations Personnelles", _isExpandedInfos, () {
              setState(() {
                _isExpandedInfos = !_isExpandedInfos;
              });
            }),
            buildInformationSection(
                "Préférences de l'application", _isExpandedPrefs, () {
              setState(() {
                _isExpandedPrefs = !_isExpandedPrefs;
              });
            }),
            buildInformationSection(
                "Paramètres de sécurité & confidentialité", _isExpandedSecurity,
                () {
              setState(() {
                _isExpandedSecurity = !_isExpandedSecurity;
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget buildProfileHeader(UserProfile userProfile) {
    return Container(
      height: SizeConfig.screenHeight * 0.48,
      color: ColorSelect.mainColor,
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.customPadding()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: ColorSelect.secondaryColor,
                radius: SizeConfig.screenWidth * 0.15,
                child: CircleAvatar(radius: SizeConfig.screenWidth * 0.14),
              ),
              CircleAvatar(
                backgroundColor: ColorSelect.secondaryColor,
                radius: SizeConfig.screenWidth * 0.07,
                child: Icon(Icons.edit, color: ColorSelect.mainColor),
              )
            ],
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.02),
          CustomTitle(
            color: ColorSelect.grey100,
            title: "${userProfile.firstName} ${userProfile.lastName}",
            fontsize: SizeConfig.customFontSizeTitle(),
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.02),
          Text(
            "${userProfile.biography}",
            style: TextStyle(
                fontSize: SizeConfig.customFontSizeText(),
                color: ColorSelect.grey100),
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.03),
        ],
      ),
    );
  }

  Widget buildInformationSection(
      String title, bool isExpanded, VoidCallback toggle) {
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
                title: title,
                fontsize: SizeConfig.screenWidth * 0.035,
              ),
              trailing: IconButton(
                onPressed: toggle,
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
              child: Column(
                children: [
                  Text("Détails pour $title",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  SizedBox(height: 10),
                  Text("Plus d'informations ici",
                      style: TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
