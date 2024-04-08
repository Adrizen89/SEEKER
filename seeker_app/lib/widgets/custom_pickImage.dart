import 'package:flutter/material.dart';
import 'dart:io';
import 'package:seeker_app/services/image_selector.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerCircle extends StatefulWidget {
  final Function(File) onImageSelected;

  ImagePickerCircle({required this.onImageSelected});

  @override
  _ImagePickerCircleState createState() => _ImagePickerCircleState();
}

class _ImagePickerCircleState extends State<ImagePickerCircle> {
  File? _image;
  final ImageSelector _imageSelector = ImageSelector();

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      print("Image sélectionnée : ${_image!.path}");
    } else {
      print("Aucune image sélectionnée.");
    }
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
