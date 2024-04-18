import 'package:flutter/material.dart';
import 'package:seeker_app/constants/colors.dart';
import 'package:seeker_app/constants/size.dart';
import 'package:seeker_app/models/discovery.dart';
import 'package:seeker_app/widgets/custom_buttons.dart';
import 'package:seeker_app/widgets/custom_minimap.dart';
import 'package:seeker_app/widgets/custom_text.dart';
import 'package:latlong2/latlong.dart';
import 'package:seeker_app/widgets/custom_textfield.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:seeker_app/services/image_selector.dart';

class DiscoveryDetailScreen extends StatefulWidget {
  final Discovery discovery;
  const DiscoveryDetailScreen({super.key, required this.discovery});

  @override
  State<DiscoveryDetailScreen> createState() => _DiscoveryDetailScreenState();
}

class _DiscoveryDetailScreenState extends State<DiscoveryDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  List<String> originUrls = [];
  bool _isEditing = false;
  final ImagePicker _picker = ImagePicker();
  final ImageSelector _imageService = ImageSelector();

  Future<void> _pickAndSetImageForIndex(int index) async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      var imageUrl = await _imageService.uploadImage(
          File(selectedImage.path), widget.discovery.id!); // Upload l'image
      setState(() {
        widget.discovery.imgUrls![index] = imageUrl!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.discovery.title);
    _descriptionController =
        TextEditingController(text: widget.discovery.description);
    if (widget.discovery.imgUrls != null &&
        widget.discovery.imgUrls!.length > 1) {
      // Stockez toutes les URLs sauf la première (principale)
      originUrls = widget.discovery.imgUrls!.sublist(1);
    }
  }

  void _cancelChanges() {
    setState(() {
      // Restaurez l'état initial
      _titleController.text = widget.discovery.title!;
      _descriptionController.text = widget.discovery.description!;
      widget.discovery.imgUrls = List.from(originUrls);
      _isEditing = false;
    });
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() {
    // Logic to save changes to Firestore
    print("Saving data...");
    _toggleEdit();
    // After saving data you might want to set state or navigate back
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: Container(),
          actions: [
            if (_isEditing)
              Container()
            else
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
                child: (widget.discovery.imgUrls?.isNotEmpty) ?? false
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
                        widget.discovery.imgUrls![0],
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
                    if (_isEditing)
                      CustomTextField(
                        hintText: _titleController.text,
                      )
                    else
                      CustomTitle(
                        title: _titleController.text,
                        color: ColorSelect.lastColor,
                        fontsize: SizeConfig.screenWidth * 0.05,
                      ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.02,
                    ),
                    if (_isEditing)
                      CustomTextField(
                        hintText: _descriptionController.text,
                      )
                    else
                      Text('${widget.discovery.description}',
                          style: TextStyle(
                              color: ColorSelect.mainColor,
                              fontSize: SizeConfig.screenWidth * 0.04)),
                    SizedBox(height: 10),
                    Text('Date: ${widget.discovery.date?.toLocal()}'),
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
                        itemCount: widget.discovery.imgUrls!.length - 1,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Container(
                              width: SizeConfig.screenWidth * 0.3,
                              child: _isEditing
                                  ? ListTile(
                                      trailing: IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () =>
                                            _pickAndSetImageForIndex(index + 1),
                                      ),
                                      title: Image.network(
                                          widget.discovery.imgUrls![index + 1],
                                          width: 100,
                                          fit: BoxFit.cover, loadingBuilder:
                                              (BuildContext context,
                                                  Widget child,
                                                  ImageChunkEvent?
                                                      loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: ColorSelect.secondaryColor,
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      }),
                                    )
                                  : ListTile(
                                      title: Image.network(
                                          widget.discovery.imgUrls![index],
                                          width: 100,
                                          fit: BoxFit.cover, loadingBuilder:
                                              (BuildContext context,
                                                  Widget child,
                                                  ImageChunkEvent?
                                                      loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: ColorSelect.secondaryColor,
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      }),
                                    )),
                        ),
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
                        '${widget.discovery.lat!.toStringAsFixed(6)} ${widget.discovery.lng!.toStringAsFixed(6)}',
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
                          position: LatLng(
                              widget.discovery.lat!, widget.discovery.lng!)),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButtonMain(
                            text:
                                _isEditing == false ? 'Modifier' : 'Je modifie',
                            onPressed: () {
                              setState(() {
                                _isEditing = true;
                                print(_isEditing);
                              });
                            }),
                        CustomButtonDelete(
                            text: _isEditing == false ? 'Supprimer' : 'Annuler',
                            onPressed: () {
                              if (_isEditing) {
                                _cancelChanges();
                              } else {}
                            })
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.03,
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
