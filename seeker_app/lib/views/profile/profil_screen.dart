import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:seeker_app/constants/colors.dart';
import 'package:seeker_app/constants/size.dart';
import 'package:seeker_app/providers/user_data_provider.dart';

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
      body: Stack(
        children: <Widget>[
          // Création des deux demies du fond
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: SizeConfig.screenHeight * 0.4,
            child: Container(
              padding: EdgeInsets.only(
                  right: SizeConfig.customPadding(),
                  left: SizeConfig.customPadding()),
              color: ColorSelect.mainColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 70,
                      ),
                      CircleAvatar()
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("${userProfile.firstName} ${userProfile.lastName}"),
                  SizedBox(
                    height: 20,
                  ),
                  Text("${userProfile.biography}"),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
          Center(
            child: Row(
              children: [
                Column(
                  children: [Text("67"), Text("découvertes")],
                ),
                Column(
                  children: [Text("inscrit le"), Text("27/08/2023")],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
