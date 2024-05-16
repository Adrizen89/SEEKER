import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeker_app/constants/colors.dart';
import 'package:seeker_app/constants/size.dart';
import 'package:seeker_app/providers/user_data_provider.dart';
import 'package:seeker_app/widgets/custom_textfield.dart';

class ModifyProfilScreen extends StatefulWidget {
  const ModifyProfilScreen({super.key});

  @override
  State<ModifyProfilScreen> createState() => _ModifyProfilScreenState();
}

class _ModifyProfilScreenState extends State<ModifyProfilScreen> {
  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProvider>(context).userProfile;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.customPadding(),
            vertical: SizeConfig.customPadding()),
        child: Form(
            child: Column(
          children: [
            CircleAvatar(
              backgroundColor: ColorSelect.secondaryColor,
              radius: SizeConfig.screenWidth * 0.15,
              child: CircleAvatar(
                radius: SizeConfig.screenWidth * 0.14,
                backgroundImage: NetworkImage("${userProfile.imageUrl}"),
              ),
            ),
            SizedBox(
              height: SizeConfig.customSizeBox(),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Biographie'),
                CustomTextField(
                  hintText: '${userProfile.biography}',
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.customSizeBox(),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nom'),
                CustomTextField(
                  hintText: '${userProfile.lastName}',
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.customSizeBox(),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Prénom'),
                CustomTextField(
                  hintText: '${userProfile.firstName}',
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.customSizeBox(),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date de naissance'),
                CustomTextField(
                  hintText: '${userProfile.dateNaissance}',
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.customSizeBox(),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email'),
                CustomTextField(
                  hintText: '${userProfile.email}',
                ),
              ],
            ),
          ],
        )),
      )),
    );
  }
}
