import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat/globals.dart';
import 'package:flutter_chat/models/customer.dart';
import 'package:flutter_chat/services/firestore_helper.dart';

class CustomerRepository {
  Future<Customer> getUser(String id) async {
    DocumentSnapshot snapshot =
        await FirestoreHelper().firebaseCustomers.doc(id).get();
    return Customer(snapshot);
  }

  addCustomer(String id, Map<String, dynamic> data) {
    FirestoreHelper().firebaseCustomers.doc(id).set(data);
  }

  updateCustomer(String id, Map<String, dynamic> data) {
    FirestoreHelper().firebaseCustomers.doc(id).update(data);
  }

  addToFavorites(String id, String favoriteId) {
    if (myUser.favorites!.contains(favoriteId)) {
      return;
    }

    FirestoreHelper().firebaseCustomers.doc(id).update({
      'favorites': FieldValue.arrayUnion([favoriteId])
    });
  }

  removeToFavorites(String id, String favoriteId) {
    if (!myUser.favorites!.contains(favoriteId)) {
      return;
    }

    FirestoreHelper().firebaseCustomers.doc(id).update({
      'favorites': FieldValue.arrayRemove([favoriteId])
    });
  }

  Future<List<String>> getFavorites(String id) async {
    DocumentSnapshot snapshot =
        await FirestoreHelper().firebaseCustomers.doc(id).get();
    return List<String>.from(snapshot['favorites']);
  }
}
