class Message {
  final String content;
  final DateTime time;
  final int senderId;
  final int receiverId;

  Message(
      {
        required this.content,
      required this.time,
      required this.receiverId,
      required this.senderId});
}

// class MessageList extends StatelessWidget {
//   final List<Message> messages;

//   MessageList({required this.messages});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: messages.length,
//       itemBuilder: (BuildContext context, int index) {
//         final message = messages[index];
//         return ListTile(
//           title: Text(
//             message.content,
//             style: TextStyle(
//               fontSize: 16.0,
//               color: message.isMe ? Colors.white : Colors.black,
//             ),
//           ),
//           subtitle: Text(
//             message.time,
//             style: const TextStyle(fontSize: 12.0),
//           ),
//           tileColor: message.isMe ? Colors.blue : Colors.grey[200],
//           contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12.0),
//             side: BorderSide(color: message.isMe ? Colors.blue : Colors.grey[200]!, width: 2.0),
//           ),
//         );
//       },
//     );
//   }
// }
