import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';

class MapService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveMarker({
    required String title,
    required String description,
    required LatLng position,
    required String imgMain,
    required List<String> imgUrls,
  }) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception('Utilisateur non connecté');

    await _db.collection('markers').add({
      'userId': userId,
      'title': title,
      'description': description,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': FieldValue.serverTimestamp(),
      'imgMain': imgMain,
      'imgUrls': imgUrls,
    });
  }

  Future<List<Marker>> fetchUserMarkers() async {
    var userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception('Utilisateur non connecté');
    }
    var markersCollection =
        _db.collection('markers').where('userId', isEqualTo: userId);
    var querySnapshot = await markersCollection.get();

    return querySnapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(data['latitude'], data['longitude']),
        child: Icon(Icons.location_on, color: Colors.red),
      );
    }).toList();
  }
}
