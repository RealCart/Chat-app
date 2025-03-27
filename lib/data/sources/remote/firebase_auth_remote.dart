import 'package:firebase_auth/firebase_auth.dart' as fb;

abstract interface class FirebaseAuthRemote {
  Future<fb.User> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<fb.User> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
}

class FirebaseAuthRemoteImpl implements FirebaseAuthRemote {
  FirebaseAuthRemoteImpl(this._firebaseAuth);

  final fb.FirebaseAuth _firebaseAuth;

  @override
  Future<fb.User> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final response = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = response.user;

    if (user == null) throw Exception("User already exist");

    return user;
  }

  @override
  Future<fb.User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final response = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = response.user;

    if (user == null) throw Exception("User already exist");

    return user;
  }
}
