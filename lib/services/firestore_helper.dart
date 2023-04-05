import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreHelper {
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  final firebaseCustomers = FirebaseFirestore.instance.collection("CUSTOMERS");
  final firebaseMessages = FirebaseFirestore.instance.collection("MESSAGES");
}
