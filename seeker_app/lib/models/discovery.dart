import 'package:cloud_firestore/cloud_firestore.dart';

class Discovery {
  final String? id;
  final String? title;
  final String? description;
  final DateTime? date;
  final double? lat;
  final double? lng;
  final List<String>? imgUrls;

  Discovery({
    this.id,
    this.title,
    this.description,
    this.date,
    this.lat,
    this.lng,
    this.imgUrls,
  });

  factory Discovery.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>?; // Utilisez un cast sûr
    if (data != null) {
      // Assurez-vous que 'imgUrls' est traité comme une liste de chaînes de caractères
      var imgUrlsDynamic = data['imgUrls'];
      List<String>? imgUrlsList;
      if (imgUrlsDynamic is List) {
        imgUrlsList = imgUrlsDynamic.map((item) => item.toString()).toList();
      }

      return Discovery(
        id: doc.id,
        title: data['title'] as String?, // Assurez-vous que le cast est sûr
        description:
            data['description'] as String?, // Cast sûr avec gestion de null
        date: data['date'] != null
            ? DateTime.fromMillisecondsSinceEpoch(data['date'] as int)
            : null,
        lat: data['latitude'] as double?,
        lng: data['longitude'] as double?,
        imgUrls: imgUrlsList,
      );
    } else {
      // Gérez le cas où data est null
      return Discovery(
        id: '',
        title: '',
        description: '',
        date: DateTime.now(),
        lat: 0.0,
        lng: 0.0,
        imgUrls: [],
      ); // Retournez un objet vide avec des valeurs par défaut
    }
  }
}
