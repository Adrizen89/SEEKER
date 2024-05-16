import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:seeker_app/constants/colors.dart';
import 'package:seeker_app/constants/size.dart';
import 'package:seeker_app/models/user_model.dart';
import 'package:seeker_app/providers/user_data_provider.dart';
import 'package:seeker_app/views/profile/modify_profil_screen.dart';
import 'package:seeker_app/widgets/custom_section_profil.dart';
import 'package:seeker_app/widgets/custom_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  int discoveriesCount = 0;

  @override
  void initState() {
    super.initState();
    fetchDiscoveriesCount();
  }

  void fetchDiscoveriesCount() async {
    int count = await getNumberOfDiscoveries();
    setState(() {
      discoveriesCount = count;
    });
  }

  Future<int> getNumberOfDiscoveries() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('markers')
          .where('userId', isEqualTo: user.uid)
          .get();
      return querySnapshot.docs.length;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProvider>(context).userProfile;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildProfileHeader(userProfile),
            Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.customPadding(),
                  right: SizeConfig.customPadding(),
                  top: SizeConfig.customPadding()),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      CustomTitle(
                        title: "$discoveriesCount",
                        color: ColorSelect.lastColor,
                        fontsize: SizeConfig.customFontSizeTitle(),
                      ),
                      Text(
                        'découvertes',
                        style: TextStyle(
                            color: ColorSelect.mainColor,
                            fontSize: SizeConfig.customFontSizeText()),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'inscrit le',
                        style: TextStyle(
                            color: ColorSelect.mainColor,
                            fontSize: SizeConfig.customFontSizeText()),
                      ),
                      CustomTitle(
                        title:
                            "${DateFormat('d/MM/yyyy').format(userProfile.dateRegister)}",
                        color: ColorSelect.lastColor,
                        fontsize: SizeConfig.customFontSizeTitle(),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SectionInfosPersos(
              name: "${userProfile.firstName} ${userProfile.lastName}",
              email: "${userProfile.email}",
              dateNaissance:
                  "${DateFormat('d/MM/yyyy').format(userProfile.dateNaissance)}",
            ),
            SectionPrefApp(),
            SectionParamsSecuConf()
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
                child: CircleAvatar(
                  radius: SizeConfig.screenWidth * 0.14,
                  backgroundImage: NetworkImage("${userProfile.imageUrl}"),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    print("URL : ${userProfile.imageUrl}");
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ModifyProfilScreen()));
                  },
                  child: Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 24, 24, 24),
                        offset: const Offset(
                          1.0,
                          1.0,
                        ),
                        blurRadius: 10.0,
                        spreadRadius: 1.0,
                      )
                    ], borderRadius: BorderRadius.circular(300)),
                    child: CircleAvatar(
                      backgroundColor: ColorSelect.secondaryColor,
                      radius: SizeConfig.screenWidth * 0.07,
                      child: Icon(Icons.edit, color: ColorSelect.mainColor),
                    ),
                  ))
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
}
