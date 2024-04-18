import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeker_app/models/discovery.dart';

Stream<List<Discovery>> fetchDiscoveriesStream(String userId) {
  return FirebaseFirestore.instance
      .collection('discoveries')
      .where('userId', isEqualTo: userId)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Discovery.fromFirestore(doc)).toList());
}
