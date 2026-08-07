import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/message.dart';
import '../services/websocket_service.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String username;

  const ChatScreen({super.key, required this.username});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final WebSocketService socket = WebSocketService();

  final TextEditingController messageController = TextEditingController();

  final List<Message> messages = [];

  @override
  void initState() {
    super.initState();

    socket.connect();

    socket.stream.listen(
      (data) {
        print("Received: $data");

        final json = jsonDecode(data);

        setState(() {
          messages.add(
            Message(
              text: json["text"],
              isMe: json["sender"] == widget.username,
              time: DateTime.now(),
            ),
          );
        });
      },
      onError: (error) {
        print("WebSocket Error: $error");
      },
      onDone: () {
        print("WebSocket Closed");
      },
    );
  }

  @override
  void dispose() {
    socket.disconnect();
    messageController.dispose();
    super.dispose();
  }

  void sendMessage() {
    final text = messageController.text.trim();

    if (text.isEmpty) return;

    socket.send(sender: widget.username, text: text);

    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.username)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return MessageBubble(message: messages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => sendMessage(),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: sendMessage,
                  icon: const Icon(Icons.send, color: Colors.blue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
