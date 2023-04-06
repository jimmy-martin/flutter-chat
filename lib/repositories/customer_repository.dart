import 'package:flutter_chat/services/firestore_helper.dart';

class CustomerRepository {
  addCustomer(String id, Map<String, dynamic> data) {
    FirestoreHelper().firebaseCustomers.doc(id).set(data);
  }

  updateCustomer(String id, Map<String, dynamic> data) {
    FirestoreHelper().firebaseCustomers.doc(id).update(data);
  }
}
