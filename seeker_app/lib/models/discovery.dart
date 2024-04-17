import 'package:cloud_firestore/cloud_firestore.dart';

class Discovery {
  final String? id;
  final String? title;
  final String? description;
  final DateTime? date;
  final double? lat;
  final double? lng;

  Discovery(
      {this.id, this.title, this.description, this.date, this.lat, this.lng});

  factory Discovery.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>?; // Utilisez un cast sûr
    if (data != null) {
      return Discovery(
        id: doc.id,
        title: data['title'] as String?, // Assurez-vous que le cast est sûr
        description:
            data['description'] as String?, // Cast sûr avec gestion de null
        date: data['date'] != null
            ? DateTime.fromMillisecondsSinceEpoch(data['date'] as int)
            : null,
        lat: data['latitude'] as double,
        lng: data['longitude'] as double,
      );
    } else {
      // Gérez le cas où data est null
      return Discovery(); // Vous pouvez choisir de retourner un objet vide ou lever une exception
    }
  }
}
