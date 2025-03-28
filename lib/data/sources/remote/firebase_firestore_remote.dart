import "package:cloud_firestore/cloud_firestore.dart";

abstract interface class FirebaseFirestoreRemote {
  Future<void> saveUserData({
    required String uid,
    required String username,
    required String? imageUrl,
  });

  Future<List<Map<String, dynamic>>> getAllUsersDataExcept(String uid);

  Future<Map<String, dynamic>?> getUserData(String uid);

  Future<void> sendMessage({
    required String chatId,
    required Map<String, dynamic> messageData,
  });

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessagesStream(String chatId);
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
    await _firestore.collection('users').doc(uid).set({
      'name': username,
      'image': imageUrl,
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getAllUsersDataExcept(
      String excludeUid) async {
    final snapshot = await _firestore.collection('users').get();
    final docs = snapshot.docs
        .where((doc) => doc.id != excludeUid)
        .map((doc) => {
              'uid': doc.id,
              ...doc.data(),
            })
        .toList();
    return docs;
  }

  @override
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) {
      return null;
    }
    return {
      'uid': doc.id,
      ...doc.data()!,
    };
  }

  @override
  Future<void> sendMessage({
    required String chatId,
    required Map<String, dynamic> messageData,
  }) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(messageData);
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessagesStream(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
