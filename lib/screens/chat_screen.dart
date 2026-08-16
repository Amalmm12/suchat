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

  bool connected = false;

  @override
  void initState() {
    super.initState();

    // Connect and register this username.
    socket.connect(username: widget.username);

    socket.stream.listen(
      (data) {
        debugPrint("ESP32 → $data");

        try {
          final json = jsonDecode(data);

          if (!mounted) return;

          // ------------------------------------------
          // USER LIST FROM ESP32
          // ------------------------------------------

          if (json["type"] == "users") {
            debugPrint("Connected users: ${json["users"]}");

            setState(() {
              connected = true;
            });

            return;
          }

          // ------------------------------------------
          // ERROR FROM ESP32
          // ------------------------------------------

          if (json["type"] == "error") {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(json["message"] ?? "WebSocket error"),
                behavior: SnackBarBehavior.floating,
              ),
            );

            return;
          }

          // ------------------------------------------
          // NORMAL EVERYONE MESSAGE
          // ------------------------------------------

          if (json["type"] == "message") {
            setState(() {
              messages.add(
                Message(
                  sender: json["sender"] ?? "Unknown",
                  text: json["text"] ?? "",
                  isMe: json["sender"] == widget.username,
                  time: _messageTime(json["time"]),
                ),
              );
            });

            return;
          }

          // ------------------------------------------
          // PERSONAL MESSAGE
          // ------------------------------------------

          if (json["type"] == "personal") {
            final sender = json["sender"] ?? "Unknown";

            final receiver = json["receiver"] ?? "";

            // Only display if this message belongs
            // to this user.
            if (sender == widget.username || receiver == widget.username) {
              setState(() {
                messages.add(
                  Message(
                    sender: sender,
                    text: json["text"] ?? "",
                    isMe: sender == widget.username,
                    time: _messageTime(json["time"]),
                  ),
                );
              });
            }

            return;
          }
        } catch (e) {
          debugPrint("JSON parsing error: $e");
        }
      },
      onError: (error) {
        debugPrint("WebSocket Error: $error");

        if (!mounted) return;

        setState(() {
          connected = false;
        });
      },
      onDone: () {
        debugPrint("WebSocket connection closed");

        if (!mounted) return;

        setState(() {
          connected = false;
        });
      },
    );

    // Give the connection a moment to establish.
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      setState(() {
        connected = socket.isConnected;
      });
    });
  }

  // ------------------------------------------
  // MESSAGE TIME
  // ------------------------------------------

  DateTime _messageTime(dynamic value) {
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }

    return DateTime.now();
  }

  // ------------------------------------------
  // DISPOSE
  // ------------------------------------------

  @override
  void dispose() {
    socket.disconnect();
    messageController.dispose();

    super.dispose();
  }

  // ------------------------------------------
  // SEND EVERYONE MESSAGE
  // ------------------------------------------

  void sendMessage() {
    final text = messageController.text.trim();

    if (text.isEmpty) {
      return;
    }

    if (!socket.isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Not connected to SuChat network"),
          behavior: SnackBarBehavior.floating,
        ),
      );

      return;
    }

    socket.send(sender: widget.username, text: text);

    messageController.clear();
  }

  // ------------------------------------------
  // DRAWER PLACEHOLDER
  // ------------------------------------------

  void comingSoon(String title, IconData icon) {
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text("$title coming soon"),
          ],
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ------------------------------------------
  // BUILD
  // ------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      drawer: _buildDrawer(),

      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: messages.isEmpty
                  ? _buildEmptyChat()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return MessageBubble(message: messages[index]);
                      },
                    ),
            ),

            _buildComposer(),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------
  // HEADER
  // ------------------------------------------

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.menu_rounded),
              );
            },
          ),

          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF1565C0),
              borderRadius: BorderRadius.circular(13),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Image.asset(
                "assets/logo.png",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.chat_rounded, color: Colors.white);
                },
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Everyone",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 3),

                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: connected ? Colors.green : Colors.red,
                      ),
                    ),

                    const SizedBox(width: 6),

                    Text(
                      connected ? "Connected" : "Disconnected",
                      style: TextStyle(
                        fontSize: 12,
                        color: connected
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFFE3F2FD),
            child: Text(
              widget.username.isNotEmpty
                  ? widget.username[0].toUpperCase()
                  : "?",
              style: const TextStyle(
                color: Color(0xFF1565C0),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------
  // DRAWER
  // ------------------------------------------

  Widget _buildDrawer() {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(22, 30, 22, 25),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0D47A1), Color(0xFF42A5F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: Text(
                      widget.username.isNotEmpty
                          ? widget.username[0].toUpperCase()
                          : "?",
                      style: const TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1565C0),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "SuChat",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    widget.username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 9),

                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: connected
                              ? Colors.greenAccent
                              : Colors.redAccent,
                        ),
                      ),

                      const SizedBox(width: 7),

                      Text(
                        connected ? "Connected" : "Disconnected",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            _drawerItem(
              icon: Icons.person_rounded,
              title: "Personal Chats",
              subtitle: "Private conversations",
              color: const Color(0xFF1565C0),
              onTap: () {
                comingSoon("Personal Chats", Icons.person_rounded);
              },
            ),

            _drawerItem(
              icon: Icons.groups_rounded,
              title: "Groups",
              subtitle: "Group conversations",
              color: Colors.deepPurple,
              onTap: () {
                comingSoon("Groups", Icons.groups_rounded);
              },
            ),

            _drawerItem(
              icon: Icons.campaign_rounded,
              title: "Everyone",
              subtitle: "Message everyone",
              color: Colors.orange,
              onTap: () {
                Navigator.pop(context);
              },
            ),

            const Divider(height: 28, indent: 20, endIndent: 20),

            _drawerItem(
              icon: Icons.location_on_rounded,
              title: "Location",
              subtitle: "Share GPS location",
              color: Colors.red,
              onTap: () {
                comingSoon("Location", Icons.location_on_rounded);
              },
            ),

            _drawerItem(
              icon: Icons.settings_rounded,
              title: "Settings",
              subtitle: "App settings",
              color: Colors.grey.shade700,
              onTap: () {
                comingSoon("Settings", Icons.settings_rounded);
              },
            ),

            const Spacer(),

            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "SuChat • Local Communication",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------
  // DRAWER ITEM
  // ------------------------------------------

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 15,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  // ------------------------------------------
  // EMPTY CHAT
  // ------------------------------------------

  Widget _buildEmptyChat() {
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
                Icons.chat_bubble_outline_rounded,
                size: 44,
                color: Color(0xFF1565C0),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Everyone Chat",
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 7),

            Text(
              "Messages sent here are broadcast\n"
              "to connected SuChat devices.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 18),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: connected
                    ? Colors.green.withValues(alpha: 0.08)
                    : Colors.red.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    connected ? Icons.wifi_rounded : Icons.wifi_off_rounded,
                    size: 17,
                    color: connected
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                  ),

                  const SizedBox(width: 7),

                  Text(
                    connected ? "ESP32 connected" : "ESP32 disconnected",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: connected
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------
  // MESSAGE COMPOSER
  // ------------------------------------------

  Widget _buildComposer() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3F6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Attachments coming soon"),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.add_rounded),
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: TextField(
              controller: messageController,
              minLines: 1,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Message everyone...",
                filled: true,
                fillColor: const Color(0xFFF1F3F6),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) {
                sendMessage();
              },
            ),
          ),

          const SizedBox(width: 8),

          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF1565C0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(Icons.send_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
