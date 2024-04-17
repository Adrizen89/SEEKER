import 'package:flutter/material.dart';
import 'package:seeker_app/constants/colors.dart';
import 'package:seeker_app/constants/size.dart';
import 'package:seeker_app/models/discovery.dart';
import 'package:seeker_app/widgets/custom_text.dart';

class DiscoveryDetailScreen extends StatelessWidget {
  final Discovery discovery;

  const DiscoveryDetailScreen({Key? key, required this.discovery})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: ColorSelect.secondaryColor,
              ),
              child: Icon(Icons.arrow_back_ios),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                radius: SizeConfig.screenWidth * 0.17,
                backgroundColor: ColorSelect.secondaryColor,
                child: Icon(
                  Icons.edit,
                  color: ColorSelect.mainColor,
                ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: SizeConfig.screenHeight * 0.3,
                width: SizeConfig.screenWidth * 1,
                color: ColorSelect.mainColor,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTitle(
                      title: discovery.title ?? 'Découverte sans titre',
                      color: ColorSelect.lastColor,
                      fontsize: SizeConfig.screenWidth * 0.05,
                    ),
                    SizedBox(height: 10),
                    Text('Date: ${discovery.date?.toLocal()}'),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.02,
                    ),
                    Text('${discovery.description}',
                        style: TextStyle(
                            color: ColorSelect.mainColor,
                            fontSize: SizeConfig.screenWidth * 0.04)),
                    SizedBox(height: 10),
                    Text('Date: ${discovery.date?.toLocal()}'),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.03,
                    ),
                    CustomTitle(
                      title: 'Autres photos',
                      color: ColorSelect.lastColor,
                      fontsize: SizeConfig.screenWidth * 0.05,
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.02,
                    ),
                    Container(
                      height: SizeConfig.screenHeight * 0.07,
                      width: SizeConfig.screenWidth * 0.3,
                      color: ColorSelect.mainColor,
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.02,
                    ),
                    CustomTitle(
                      title: 'Coordonnées GPS',
                      color: ColorSelect.lastColor,
                      fontsize: SizeConfig.screenWidth * 0.05,
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.02,
                    ),
                    Text(
                        '${discovery.lat!.toStringAsFixed(6)} ${discovery.lng!.toStringAsFixed(6)}',
                        style: TextStyle(
                            color: ColorSelect.mainColor,
                            fontSize: SizeConfig.screenWidth * 0.04)),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.03,
                    ),
                    Container(
                      height: SizeConfig.screenHeight * 0.2,
                      width: SizeConfig.screenWidth * 1,
                      color: ColorSelect.mainColor,
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
