import 'package:flutter_chat/services/firestore_helper.dart';

class UserRepository {
  addUser(String id, Map<String, dynamic> data) {
    FirestoreHelper().firebaseUsers.doc(id).set(data);
  }

  updateUser(String id, Map<String, dynamic> data) {
    FirestoreHelper().firebaseUsers.doc(id).update(data);
  }
}