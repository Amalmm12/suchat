import 'package:flutter/material.dart';
import '../services/websocket_service.dart';

class PersonalChatScreen extends StatelessWidget {
  final String username;
  final String receiver;

  const PersonalChatScreen({
    super.key,
    required this.username,
    required this.receiver,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with $receiver')),
      body: Center(child: Text('Chat with $receiver')),
    );
  }
}

class PersonalChatsScreen extends StatefulWidget {
  final String username;

  const PersonalChatsScreen({super.key, required this.username});

  @override
  State<PersonalChatsScreen> createState() => _PersonalChatsScreenState();
}

class _PersonalChatsScreenState extends State<PersonalChatsScreen> {
  final WebSocketService socket = WebSocketService();

  List<String> users = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    connectToNetwork();
  }

  void connectToNetwork() {
    socket.connect(username: widget.username);

    socket.stream.listen(
      (data) {
        try {
          final json = socket.decodeMessage(data);

          if (json["type"] == "users") {
            final List<dynamic> userList = json["users"] ?? [];

            final otherUsers = userList
                .map((user) => user.toString())
                .where((user) => user != widget.username)
                .toList();

            if (!mounted) return;

            setState(() {
              users = otherUsers;
              loading = false;
            });
          }
        } catch (e) {
          debugPrint("User list error: $e");
        }
      },
      onError: (error) {
        debugPrint("WebSocket error: $error");

        if (!mounted) return;

        setState(() {
          loading = false;
        });
      },
    );
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  String firstLetter(String name) {
    if (name.isEmpty) return "?";
    return name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Personal Chats",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Private conversations",
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
          ? _emptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: users.length,
              itemBuilder: (context, index) {
                return _userCard(users[index]);
              },
            ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.person_search_rounded,
                size: 45,
                color: Color(0xFF1565C0),
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              "No one nearby",
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              "When another SuChat user connects\n"
              "to the local network, they will appear here.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _userCard(String name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PersonalChatScreen(
                  username: widget.username,
                  receiver: name,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: const Color(0xFFE3F2FD),
                      child: Text(
                        firstLetter(name),
                        style: const TextStyle(
                          color: Color(0xFF1565C0),
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),

                          const SizedBox(width: 6),

                          Text(
                            "Available nearby",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.chat_rounded,
                    color: Color(0xFF1565C0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
