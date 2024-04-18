import 'package:flutter/material.dart';
import 'package:seeker_app/constants/colors.dart';
import 'package:seeker_app/constants/size.dart';
import 'package:seeker_app/models/discovery.dart';
import 'package:seeker_app/widgets/custom_minimap.dart';
import 'package:seeker_app/widgets/custom_text.dart';
import 'package:latlong2/latlong.dart';

class DiscoveryDetailScreen extends StatelessWidget {
  final Discovery discovery;

  const DiscoveryDetailScreen({
    Key? key,
    required this.discovery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: Container(),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: CircleAvatar(
                radius: SizeConfig.screenWidth * 0.17,
                backgroundColor: ColorSelect.mainColor,
                child: Icon(
                  size: SizeConfig.screenWidth * 0.09,
                  Icons.clear,
                  color: ColorSelect.secondaryColor,
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
                child: (discovery.imgUrls?.isNotEmpty) ?? false
                    ? Image.network(
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              color: ColorSelect.secondaryColor,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        fit: BoxFit.cover,
                        discovery.imgUrls![0],
                        errorBuilder: (context, error, stackTrace) {
                          // Gestion des erreurs de chargement d'image
                          return Icon(Icons.image_not_supported,
                              size: 100, color: Colors.white);
                        },
                      )
                    : Icon(Icons.note_sharp),
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
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: discovery.imgUrls!.length -
                            1, // Exclure l'image principale
                        itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              width: SizeConfig.screenWidth * 0.3,
                              child: Image.network(
                                  discovery.imgUrls![index + 1],
                                  width: 100,
                                  fit: BoxFit.cover, loadingBuilder:
                                      (BuildContext context, Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: ColorSelect.secondaryColor,
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              }),
                            )),
                      ),
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
                      child: MiniMap(
                          position: LatLng(discovery.lat!, discovery.lng!)),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
