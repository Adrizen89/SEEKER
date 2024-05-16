import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageSelector {
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<File?> pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<String?> uploadImage(File imageFile, String userId) async {
    try {
      String filePath =
          'markers/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref = _storage.ref().child(filePath);
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      // Convertir l'URL de l'image en une référence de Firebase Storage
      Reference ref = _storage.refFromURL(imageUrl);

      // Supprimer le fichier
      await ref.delete();
    } catch (e) {
      print("Erreur lors de la suppression de l'image: $e");
    }
  }
}
