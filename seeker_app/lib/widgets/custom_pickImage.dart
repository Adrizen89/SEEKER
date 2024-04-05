import 'package:flutter/material.dart';
import 'dart:io';
import 'package:seeker_app/services/image_selector.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerCircle extends StatefulWidget {
  @override
  _ImagePickerCircleState createState() => _ImagePickerCircleState();
}

class _ImagePickerCircleState extends State<ImagePickerCircle> {
  File? _image;
  final ImageSelector _imageSelector = ImageSelector();

  void _pickImage() async {
    // Affiche un menu de choix : Galerie ou Caméra
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Galerie'),
                  onTap: () async {
                    var image =
                        await _imageSelector.pickImage(ImageSource.gallery);
                    setState(() => _image = image);
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Caméra'),
                onTap: () async {
                  var image =
                      await _imageSelector.pickImage(ImageSource.camera);
                  setState(() => _image = image);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _pickImage,
      child: CircleAvatar(
        radius: 60, // Ajustez la taille selon vos besoins
        backgroundColor: Colors.grey[300],
        backgroundImage: _image != null ? FileImage(_image!) : null,
        child: _image == null
            ? Icon(
                Icons.add,
                size: 50, // Taille de l'icône +
                color: Colors.white,
              )
            : null, // Si une image est sélectionnée, l'icône "+" disparaît
      ),
    );
  }
}
