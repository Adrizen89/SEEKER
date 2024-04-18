import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seeker_app/constants/colors.dart';
import 'package:seeker_app/constants/size.dart';
import 'package:seeker_app/providers/user_data_provider.dart';
import 'package:seeker_app/services/image_selector.dart';
import 'package:seeker_app/services/map/map_services.dart';
import 'package:seeker_app/widgets/custom_buttons.dart';
import 'package:seeker_app/widgets/custom_minimap.dart';
import 'package:seeker_app/widgets/custom_text.dart';
import 'package:seeker_app/widgets/custom_textfield.dart';
import 'package:latlong2/latlong.dart';
import 'dart:io';
import 'package:provider/provider.dart';

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
  final ImageSelector _imageSelector = ImageSelector();
  File? _image;
  List<File> additionalImages = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAndSetImage() async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        _image = File(selectedImage.path);
      });
    }
  }

  Future<void> _pickAdditionalImage() async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        additionalImages.add(File(selectedImage.path));
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    String userId =
        Provider.of<UserProvider>(context, listen: false).userProfile.uid;
    String? imageUrl = await _imageSelector.uploadImage(image, userId);
    return imageUrl;
  }

  void _saveMarker() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Le titre et la description sont nécessaires.")));
      return;
    }

    List<String> imgUrls = [];
    if (_image != null) {
      String? imageUrl = await _uploadImage(_image!);
      if (imageUrl != null) imgUrls.add(imageUrl);
    }

    for (File image in additionalImages) {
      String? imageUrl = await _uploadImage(image);
      if (imageUrl != null) imgUrls.add(imageUrl);
    }

    try {
      await _mapService.saveMarker(
          title: _titleController.text,
          description: _descriptionController.text,
          position: widget.position,
          imgUrls: imgUrls);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: _pickAndSetImage,
              child: Container(
                height: SizeConfig.screenHeight * 0.3,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  image: _image != null
                      ? DecorationImage(
                          image: FileImage(_image!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _image == null
                    ? Icon(Icons.add_a_photo, size: 50, color: Colors.white)
                    : SizedBox(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  right: SizeConfig.customPadding(),
                  left: SizeConfig.customPadding()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: SizeConfig.customSizeBox()),
                  CustomTextField(
                    hintText: 'Nom de la découverte',
                    controller: _titleController,
                  ),
                  SizedBox(height: SizeConfig.customSizeBox()),
                  CustomTextField(
                    hintText: 'Description',
                    controller: _descriptionController,
                  ),
                  SizedBox(height: SizeConfig.customSizeBox()),
                  CustomTitle(
                    title: 'Autres photos',
                    color: ColorSelect.lastColor,
                    fontsize: SizeConfig.screenWidth * 0.04,
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.1,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: additionalImages.length +
                          1, // Add one for the add button
                      itemBuilder: (context, index) {
                        if (index == additionalImages.length) {
                          // This is the add button
                          return GestureDetector(
                            onTap: _pickAdditionalImage,
                            child: Container(
                              width: SizeConfig.screenWidth * 0.3,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                              ),
                              child: Icon(Icons.add, color: Colors.white),
                            ),
                          );
                        } else {
                          // This is one of the images
                          return Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Image.file(additionalImages[index],
                                width: SizeConfig.screenWidth * 0.3,
                                height: SizeConfig.screenHeight * 0.3),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: SizeConfig.customSizeBox()),
                  CustomTitle(
                    title: 'Coordonnées GPS',
                    color: ColorSelect.lastColor,
                    fontsize: SizeConfig.screenWidth * 0.04,
                  ),
                  SizedBox(height: SizeConfig.customSizeBox()),
                  Container(
                    height: SizeConfig.screenHeight * 0.2,
                    width: SizeConfig.screenWidth * 1,
                    color: ColorSelect.lastColor,
                    child: MiniMap(position: widget.position),
                  ),
                  SizedBox(height: SizeConfig.customSizeBox()),
                  CustomButtonSecondary(
                      text: 'Enregistrer', onPressed: _saveMarker),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
