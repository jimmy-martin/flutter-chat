import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat/models/customer.dart';
import 'package:flutter_chat/repositories/customer_repository.dart';

class FirestoreHelper {
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  final firebaseCustomers = FirebaseFirestore.instance.collection("CUSTOMERS");
  final firebaseMessages = FirebaseFirestore.instance.collection("MESSAGES");

  Future<Customer> register(
      String email, String password, String lastname, String firstname, String language) async {
    UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);

    User? user = credential.user;

    if (user == null) {
      return Future.error("Erreur lors de la création du compte");
    } else {
      String uid = user.uid;
      Map<String, dynamic> map = {
        "lastname": lastname,
        "firstname": firstname,
        "email": email,
        "language": language,
        "favorites": []
      };

      CustomerRepository().addCustomer(uid, map);
      return CustomerRepository().getUser(uid);
    }
  }

  Future<Customer> connect(String email, String password) async {
    UserCredential credential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    User? user = credential.user;
    if (user == null) {
      return Future.error("Erreur lors de la connexion");
    } else {
      String uid = user.uid;
      return CustomerRepository().getUser(uid);
    }
  }

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
