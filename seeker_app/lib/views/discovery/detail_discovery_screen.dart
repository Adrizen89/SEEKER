import 'package:flutter/material.dart';
import 'package:seeker_app/constants/colors.dart';
import 'package:seeker_app/constants/size.dart';
import 'package:seeker_app/models/discovery.dart';
import 'package:seeker_app/services/discovery/discovery.dart';
import 'package:seeker_app/widgets/custom_buttons.dart';
import 'package:seeker_app/widgets/custom_minimap.dart';
import 'package:seeker_app/widgets/custom_text.dart';
import 'package:latlong2/latlong.dart';
import 'package:seeker_app/widgets/custom_textfield.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  late String originMainImage;
  bool _isEditing = false;
  final ImagePicker _picker = ImagePicker();
  final ImageSelector _imageService = ImageSelector();
  FirestoreService _db = FirestoreService();
  List<int> _imagesToDelete = [];
  List<File> _newImages = [];

  Future<void> _pickAndSetImageForIndex(int index) async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      var imageUrl = await _imageService.uploadImage(
          File(selectedImage.path), widget.discovery.id!);
      if (imageUrl != null) {
        setState(() {
          if (index >= widget.discovery.imgUrls!.length) {
            widget.discovery.imgUrls!.add(imageUrl);
          } else {
            widget.discovery.imgUrls![index] = imageUrl;
          }
        });
      }
    }
  }

  Future<void> _pickAndSetMainImage() async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      var imageUrl = await _imageService.uploadImage(
          File(selectedImage.path), widget.discovery.id!);
      setState(() {
        widget.discovery.imgMain = imageUrl;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialisation des contrôleurs avec les valeurs actuelles ou des chaînes vides si null
    _titleController =
        TextEditingController(text: widget.discovery.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.discovery.description ?? '');

    // Stockage des URLs originales pour pouvoir annuler les modifications si nécessaire
    originUrls = List<String>.from(widget.discovery.imgUrls ?? []);
    originMainImage = widget.discovery.imgMain ?? '';

    // Log des valeurs initiales pour le débogage
    print("InitState: Title is '${widget.discovery.title}'");
    print("InitState: Description is '${widget.discovery.description}'");

    // Ajout d'écouteurs pour tracer les changements de texte
    _titleController.addListener(() {
      print("Title from controller: ${_titleController.text}");
    });
    _descriptionController.addListener(() {
      print("Description from controller: ${_descriptionController.text}");
    });

    // Si vous avez besoin de mettre à jour l'état après le chargement initial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          // Vous pourriez vouloir mettre à jour l'état ici si nécessaire
          // Par exemple, recharger d'autres données basées sur les titres/descriptions
        });
      }
    });
  }

  void _cancelChanges() {
    setState(() {
      // Réinitialiser les contrôleurs avec les valeurs d'origine
      _titleController.text = widget.discovery.title ?? '';
      _descriptionController.text = widget.discovery.description ?? '';

      // Réinitialiser l'URL de l'image principale et les URLs supplémentaires à leurs valeurs d'origine
      widget.discovery.imgMain = originMainImage;
      widget.discovery.imgUrls =
          List.from(originUrls); // Copie profonde pour éviter la mutation
      _imagesToDelete.clear();
      _isEditing = false;
    });
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _updateDiscovery() async {
    // Premièrement, télécharger les nouvelles images et obtenir les URLs
    for (File imageFile in _newImages) {
      String? imageUrl =
          await _imageService.uploadImage(imageFile, widget.discovery.id!);
      if (imageUrl != null) {
        widget.discovery.imgUrls!.add(imageUrl);
      }
    }
    _newImages.clear(); // Vider la liste des nouvelles images après l'ajout

    // Préparer les données à mettre à jour
    Map<String, dynamic> updatedData = {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'imgMain': widget.discovery.imgMain,
      'imgUrls': widget.discovery.imgUrls,
    };

    // Mettre à jour Firestore avec les données actualisées
    _db.updateDiscovery(widget.discovery.id!, updatedData).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Découverte modifiée avec succès !')));
      // Mettre à jour l'état local avec les nouvelles données
      setState(() {
        widget.discovery.title = _titleController.text;
        widget.discovery.description = _descriptionController.text;
      });
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Échec de la mise à jour de la découverte : $error')));
    });
  }

  void _updateImageUrlsInFirestore() {
    Map<String, dynamic> updatedData = {
      'imgUrls': widget.discovery.imgUrls,
    };

    _db.updateDiscovery(widget.discovery.id!, updatedData).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Les images ont été mises à jour avec succès.')));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Échec de la mise à jour des images : $error')));
    });
  }

  void _removeImageAtIndex(int index) async {
    // URL de l'image à supprimer
    String imageUrl = widget.discovery.imgUrls![index];

    // Mise à jour de l'état local pour enlever l'image de la liste
    setState(() {
      widget.discovery.imgUrls!.removeAt(index);
    });

    // Supprimer l'image de Firebase Storage
    await _imageService.deleteImage(imageUrl);

    // Mettre à jour la liste des URLs dans Firestore
    _updateImageUrlsInFirestore();
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Supprimer l'image"),
          content: Text("Êtes-vous sûr de vouloir supprimer cette image ?"),
          actions: <Widget>[
            TextButton(
              child: Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Supprimer"),
              onPressed: () {
                // Marquer l'image pour la suppression et fermer le dialogue
                _imagesToDelete.add(index);
                Navigator.of(context).pop();
                // Retirer visuellement l'image
                setState(() {
                  widget.discovery.imgUrls!.removeAt(index);
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _applyChanges() {
    // Supprimer les images marquées pour suppression
    _imagesToDelete.sort((a, b) =>
        b.compareTo(a)); // Tri décroissant pour éviter les erreurs d'indice
    for (int index in _imagesToDelete.reversed) {
      String imageUrl = widget.discovery.imgUrls![index];
      _imageService.deleteImage(imageUrl);
    }
    _imagesToDelete.clear();

    // Mettre à jour Firestore avec les données restantes
    Map<String, dynamic> updatedData = {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'imgUrls': widget.discovery.imgUrls,
      // Assurez-vous d'inclure tous les champs nécessaires à la mise à jour
    };

    _db.updateDiscovery(widget.discovery.id!, updatedData).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Modifications enregistrées avec succès!')));
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Échec de la mise à jour: $error')));
    });
  }

  Future<void> _pickAndAddNewImage() async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        _newImages.add(File(selectedImage.path));
      });
    }
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
              // Image MAIN
              Stack(
                children: [
                  Container(
                    height: SizeConfig.screenHeight * 0.3,
                    width: SizeConfig.screenWidth * 1,
                    child: widget.discovery.imgMain?.isNotEmpty ?? false
                        ? CachedNetworkImage(
                            imageUrl: widget.discovery.imgMain!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Icon(
                                Icons.image_not_supported,
                                size: 100,
                                color: Colors.white),
                          )
                        : Icon(Icons.note_sharp,
                            size: 100, color: Colors.white),
                  ),
                  if (_isEditing)
                    Positioned(
                      right: 50,
                      bottom: 30,
                      child: InkWell(
                        onTap: _pickAndSetMainImage,
                        child: CircleAvatar(
                          backgroundColor: ColorSelect.mainColor,
                          child: Icon(Icons.edit,
                              color: ColorSelect.secondaryColor),
                        ),
                      ),
                    )
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_isEditing)
                      CustomTextField(
                        hintText: _titleController.text,
                        controller: _titleController,
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
                        controller: _descriptionController,
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
                    // Autre IMG
                    Container(
                      height: 100,
                      child: Container(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.discovery.imgUrls!.length +
                              _newImages.length +
                              1, // Plus one for the add button
                          itemBuilder: (context, index) {
                            if (index < widget.discovery.imgUrls!.length) {
                              // Existing images
                              return _buildImageTile(
                                  widget.discovery.imgUrls![index], index);
                            } else if (index <
                                widget.discovery.imgUrls!.length +
                                    _newImages.length) {
                              // New images
                              File newImage = _newImages[
                                  index - widget.discovery.imgUrls!.length];
                              return _buildNewImageTile(newImage, index);
                            }
                            if (_isEditing) {
                              // Add new image button
                              return GestureDetector(
                                onTap: _pickAndAddNewImage,
                                child: Container(
                                  width: SizeConfig.screenWidth * 0.4,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(Icons.add,
                                      size: 50, color: Colors.white),
                                ),
                              );
                            }
                          },
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
                              if (_isEditing == true) {
                                _updateDiscovery();
                              }
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

  Widget _buildImageTile(String imageUrl, int index) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: SizeConfig.customMargin()),
          width: SizeConfig.screenWidth * 0.4,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
                image: CachedNetworkImageProvider(imageUrl), fit: BoxFit.cover),
          ),
        ),
        if (_isEditing)
          Positioned(
            top: 5,
            right: 5,
            child: InkWell(
              onTap: () => _pickAndSetImageForIndex(index),
              child: CircleAvatar(
                backgroundColor: Colors.white60,
                child: Icon(Icons.edit, color: Colors.black),
              ),
            ),
          ),
        if (_isEditing)
          Positioned(
            top: 5,
            left: 5,
            child: InkWell(
              onTap: () => _showDeleteConfirmationDialog(index),
              child: CircleAvatar(
                backgroundColor: Colors.red,
                child: Icon(Icons.delete, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNewImageTile(File imageFile, int index) {
    return Stack(
      children: [
        Container(
          width: SizeConfig.screenWidth * 0.4,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image:
                DecorationImage(image: FileImage(imageFile), fit: BoxFit.cover),
          ),
        ),
        if (_isEditing)
          Positioned(
            top: 5,
            right: 5,
            child: InkWell(
              onTap: () {
                setState(() {
                  _newImages.removeAt(index - widget.discovery.imgUrls!.length);
                });
              },
              child: CircleAvatar(
                backgroundColor: Colors.red,
                child: Icon(Icons.delete, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
