import "package:cloud_firestore/cloud_firestore.dart";

abstract interface class FirebaseFirestoreRemote {
  Future<void> saveUserData({
    required String uid,
    required String username,
    required String? imageUrl,
  });
}

class FirebaseFirestoreRemoteImpl implements FirebaseFirestoreRemote {
  FirebaseFirestoreRemoteImpl(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<void> saveUserData({
    required String uid,
    required String username,
    required String? imageUrl,
  }) async {
    final response = await _firestore.collection('users').doc(uid).set({
      'name': username,
      'image': imageUrl,
    });
  }
}
