import 'package:flutter/material.dart';
import 'package:seeker_app/constants/colors.dart';
import 'package:seeker_app/constants/size.dart';
import 'package:seeker_app/services/map/map_services.dart';
import 'package:seeker_app/widgets/custom_buttons.dart';
import 'package:seeker_app/widgets/custom_textfield.dart';
import 'package:latlong2/latlong.dart';

class MarkerDetailScreen extends StatefulWidget {
  final LatLng position;
  const MarkerDetailScreen({
    super.key,
    required this.position,
  });

  @override
  State<MarkerDetailScreen> createState() => _MarkerDetailScreenState();
}

class _MarkerDetailScreenState extends State<MarkerDetailScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final MapService _mapService = MapService();

  void _saveMarker() async {
    try {
      await _mapService.saveMarker(
        title: _titleController.text,
        description: _descriptionController.text,
        position: widget.position,
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios)),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Image
              Container(
                color: Colors.red,
                width: SizeConfig.screenWidth * 1,
                height: SizeConfig.screenHeight * 0.3,
              ),
              Padding(
                padding: EdgeInsets.all(SizeConfig.customPadding()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre
                    CustomTextField(
                      hintText: 'Nom de la découverte',
                      controller: _titleController,
                    ),
                    SizedBox(
                      height: SizeConfig.customSizeBox(),
                    ),
                    // Description
                    CustomTextField(
                      hintText: 'Description',
                      controller: _descriptionController,
                    ),
                    SizedBox(
                      height: SizeConfig.customSizeBox(),
                    ),
                    // Autres photos
                    Text(
                      'Autres photos',
                      style: TextStyle(color: ColorSelect.lastColor),
                    ),
                    SizedBox(
                      height: SizeConfig.customSizeBox(),
                    ),
                    Container(
                      width: SizeConfig.screenWidth * 0.4,
                      height: SizeConfig.screenHeight * 0.13,
                      color: Colors.red,
                    ),
                    SizedBox(
                      height: SizeConfig.customSizeBox(),
                    ),
                    // Coordonnées GPS
                    Text(
                      'Coordonnées GPS',
                      style: TextStyle(color: ColorSelect.lastColor),
                    ),
                    SizedBox(
                      height: SizeConfig.customSizeBox(),
                    ),
                    Text(
                        '${widget.position.latitude.toStringAsFixed(6)} ${widget.position.longitude.toStringAsFixed(6)}'),

                    SizedBox(
                      height: SizeConfig.customSizeBox(),
                    ),
                    // Map
                    Container(
                      width: SizeConfig.screenWidth * 0.8,
                      height: SizeConfig.screenHeight * 0.2,
                      color: Colors.red,
                    ),
                    SizedBox(
                      height: SizeConfig.customSizeBox(),
                    ),
                    CustomButtonSecondary(
                        text: 'Ajouter', onPressed: _saveMarker),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
