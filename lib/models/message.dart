import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  late String id;
  late String content;
  late Timestamp time;
  late String senderId;
  late String receiverId;

  Message(
      {required this.id,
      required this.content,
      required this.time,
      required this.receiverId,
      required this.senderId});
}
