import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/models/User.dart';
import 'Service.dart';

class AuthFirestoreService {
  static final AuthFirestoreService _practiceTestFirestoreService =
  AuthFirestoreService._internal();

  factory AuthFirestoreService() {
    return _practiceTestFirestoreService;
  }

  AuthFirestoreService._internal();

  Future<void> saveUser(FirebaseUser user) {
    return FirestoreService().updateDocument(
        'users',
        user.uid,
        {
          "name": user.displayName,
          "photo_url": user.photoUrl,
          "email": user.email,
        },
        merge: true);
  }

  Stream<User> getUser(String id) {
    return FirestoreService().getDocument('users', id).map(
          (doc) => User.fromMap(doc.data, doc.documentID),
    );
  }

}

