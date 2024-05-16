import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeker_app/models/discovery.dart';

Stream<List<Discovery>> fetchDiscoveriesStream(String userId) {
  return FirebaseFirestore.instance
      .collection('markers')
      .where('userId', isEqualTo: userId)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Discovery.fromFirestore(doc)).toList());
}

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> updateDiscovery(String id, Map<String, dynamic> data) async {
    try {
      await _db.collection('markers').doc(id).update(data);
      print("Updating document with ID: ${id}");
      print("Data : ${data}");
      print("Discovery updated successfully.");
    } catch (e) {
      print("Error updating discovery: $e");
      throw e;
    }
  }
}
