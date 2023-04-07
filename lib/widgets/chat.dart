import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/globals.dart';
import 'package:flutter_chat/models/customer.dart';
import 'package:flutter_chat/models/message.dart';
import 'package:flutter_chat/repositories/message_repository.dart';
import 'package:flutter_chat/services/firestore_helper.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class Chat extends StatefulWidget {
  final Customer customer;

  const Chat({Key? key, required this.customer}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _messageController = TextEditingController();
  final MessageRepository _messageRepository = MessageRepository();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.customer.fullName)),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirestoreHelper().firebaseMessages.orderBy('time').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Text(snapshot.error.toString());
        }

        List<QueryDocumentSnapshot> messages = snapshot.data!.docs;
        return ListView.builder(
          controller: _scrollController,
          itemCount: messages.length,
          itemBuilder: (context, index) {

            final message = Message(
              id: messages[index]['id'],
              content: messages[index]['content'],
              time: messages[index]['time'],
              senderId: messages[index]['senderId'],
              receiverId: messages[index]['receiverId'],
            );

            if (message.receiverId == widget.customer.id &&
                    message.senderId == myUser.id ||
                message.receiverId == myUser.id &&
                    message.senderId == widget.customer.id) {
              bool isSentByCurrentUser = message.senderId == myUser.id;
              return _buildMessageBubble(message, isSentByCurrentUser);
            } else {
              return Container();
            }
          },
        );
      },
    );
  }

  Widget _buildMessageBubble(Message message, bool isSentByCurrentUser) {
    final formatter = DateFormat('HH:mm');
    final hours = formatter.format(message.time.toDate());

    return Align(
      alignment:
          isSentByCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSentByCurrentUser ? defaultColor : Colors.grey,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              hours,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Tapez votre message ici",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    String content = _messageController.text.trim();
    if (content.isEmpty) return;

    Message message = Message(
      id: randomAlphaNumeric(20),
      content: content,
      time: Timestamp.now(),
      senderId: myUser.id,
      receiverId: widget.customer.id,
    );

    _messageRepository.sendMessage(message);
    _messageController.clear();

    _scrollToBottom();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
