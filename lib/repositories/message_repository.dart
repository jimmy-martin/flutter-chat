import 'package:flutter_chat/models/message.dart';
import 'package:flutter_chat/services/firestore_helper.dart';

class MessageRepository {
  Future<void> sendMessage(Message message) {
    return FirestoreHelper().firebaseMessages.add({
      'id': message.id,
      'content': message.content,
      'time': message.time,
      'senderId': message.senderId,
      'receiverId': message.receiverId,
    });
  }
}
