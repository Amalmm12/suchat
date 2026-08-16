class Message {
  final String sender;
  final String text;
  final bool isMe;
  final DateTime time;

  Message({
    required this.sender,
    required this.text,
    required this.isMe,
    required this.time,
  });
}
