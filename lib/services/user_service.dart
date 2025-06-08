import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final _firestore = FirebaseFirestore.instance;

  Future<void> createOrUpdateUserProfile(User user, {String? displayName, String? bio}) async {
    await _firestore.collection('users').doc(user.uid).set({
      'email': user.email,
      'displayName': displayName ?? '',
      'bio': bio ?? '',
      'photoUrl': '',
    }, SetOptions(merge: true));
  }

  Stream<DocumentSnapshot> getUserProfile(String uid) {
    return _firestore.collection('users').doc(uid).snapshots();
  }

  Stream<QuerySnapshot> getAllUsers() {
    return _firestore.collection('users').snapshots();
  }
}
