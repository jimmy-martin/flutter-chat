import 'package:cloud_firestore/cloud_firestore.dart';
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
}
