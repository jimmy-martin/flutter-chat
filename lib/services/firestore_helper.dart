import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreHelper {
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  final firebaseCustomers = FirebaseFirestore.instance.collection("CUSTOMERS");
  final firebaseMessages = FirebaseFirestore.instance.collection("MESSAGES");

  Future<String> uploadImage(
      {required String folder,
      required String personnalFolder,
      required String imageName,
      required Uint8List bytesImage}) async {
    String url = "";
    TaskSnapshot taskSnapshot = await storage
        .ref("$folder/$personnalFolder/$imageName")
        .putData(bytesImage);
    url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }
}
