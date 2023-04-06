import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat/globals.dart';

class Customer {

  late String id;
  late String firstname;
  late String lastname;
  String? avatar;
  DateTime? birthday;
  String? nickname;
  late String email;
  List? favorites;

  String get fullName {
    return "$firstname $lastname";
  }

  Customer(DocumentSnapshot snapshot) {
    id = snapshot.id;
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    firstname = map['firstname'];
    lastname = map['lastname'];
    email = map['email'];
    avatar = map["avatar"] ?? defaultImage;
    favorites = map["favorites"] ?? [];
    Timestamp? provisionalTime = map["birthday"];
    if (provisionalTime == null) {
      birthday = DateTime.now();
    } else {
      birthday = provisionalTime.toDate();
    }
  }

  Customer.empty() {
    id = "";
    firstname = "";
    lastname = "";
    email = "";
  }
}
