import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/message.dart';
import '../services/websocket_service.dart';
import '../widgets/message_bubble.dart';
import 'personal_chats_screen.dart';

class ChatScreen extends StatefulWidget {
  final String username;

  const ChatScreen({super.key, required this.username});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final WebSocketService socket = WebSocketService();

  final TextEditingController messageController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  final List<Message> messages = [];

  List<String> nearbyUsers = [];

  bool esp32Connected = false;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    connectToSuChat();
  }

  void connectToSuChat() {
    socket.connect(username: widget.username);

    socket.stream.listen(
      (data) {
        debugPrint("ESP32 → $data");

        try {
          final dynamic decoded = jsonDecode(data);

          if (decoded is! Map) {
            return;
          }

          final Map<String, dynamic> json = Map<String, dynamic>.from(decoded);

          if (!mounted) return;

          // ======================================================
          // USERS
          // ======================================================

          if (json["type"] == "users") {
            final List<dynamic> users = json["users"] ?? [];

            final List<String> otherUsers = users
                .map((user) => user.toString())
                .where((user) => user.isNotEmpty && user != widget.username)
                .toList();

            setState(() {
              nearbyUsers = otherUsers;
              esp32Connected = true;
            });

            debugPrint("Nearby users: $nearbyUsers");

            return;
          }

          // ======================================================
          // ERROR
          // ======================================================

          if (json["type"] == "error") {
            _showMessage(json["message"]?.toString() ?? "WebSocket error");

            return;
          }

          // ======================================================
          // EVERYONE MESSAGE
          // ======================================================

          if (json["type"] == "message") {
            final String sender = json["sender"]?.toString() ?? "Unknown";

            final String text = json["text"]?.toString() ?? "";

            if (text.isEmpty) {
              return;
            }

            setState(() {
              messages.add(
                Message(
                  sender: sender,
                  text: text,
                  isMe: sender == widget.username,
                  time: _messageTime(json["time"]),
                ),
              );
            });

            _scrollToBottom();

            return;
          }

          // ======================================================
          // PERSONAL MESSAGE
          // ======================================================

          if (json["type"] == "personal") {
            final String sender = json["sender"]?.toString() ?? "";

            final String receiver = json["receiver"]?.toString() ?? "";

            final bool belongsToMe =
                sender == widget.username || receiver == widget.username;

            if (!belongsToMe) {
              return;
            }

            final String text = json["text"]?.toString() ?? "";

            if (text.isEmpty) {
              return;
            }

            setState(() {
              messages.add(
                Message(
                  sender: sender,
                  text: text,
                  isMe: sender == widget.username,
                  time: _messageTime(json["time"]),
                ),
              );
            });

            _scrollToBottom();

            return;
          }
        } catch (e) {
          debugPrint("JSON parsing error: $e");
        }
      },

      onError: (error) {
        debugPrint("WebSocket error: $error");

        if (!mounted) return;

        setState(() {
          esp32Connected = false;
          nearbyUsers.clear();
        });
      },

      onDone: () {
        debugPrint("WebSocket connection closed");

        if (!mounted) return;

        setState(() {
          esp32Connected = false;
          nearbyUsers.clear();
        });
      },
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      setState(() {
        esp32Connected = socket.isConnected;
      });
    });
  }

  // ============================================================
  // MESSAGE TIME
  // ============================================================

  DateTime _messageTime(dynamic value) {
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }

    return DateTime.now();
  }

  // ============================================================
  // SEND MESSAGE
  // ============================================================

  void sendMessage() {
    final String text = messageController.text.trim();

    if (text.isEmpty) {
      return;
    }

    if (!socket.isConnected) {
      _showMessage("SuChat is not connected");

      return;
    }

    if (nearbyUsers.isEmpty) {
      _showMessage("No nearby users connected");

      return;
    }

    socket.send(sender: widget.username, text: text);

    messageController.clear();

    FocusScope.of(context).unfocus();
  }

  // ============================================================
  // OPEN PERSONAL CHATS
  // ============================================================

  void openPersonalChats() {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PersonalChatsScreen(username: widget.username),
      ),
    );
  }

  // ============================================================
  // COMING SOON
  // ============================================================

  void comingSoon(String title, IconData icon) {
    Navigator.pop(context);

    _showMessage("$title coming soon", icon: icon);
  }

  // ============================================================
  // SNACKBAR
  // ============================================================

  void _showMessage(String text, {IconData? icon}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
            ],
            Expanded(child: Text(text)),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SCROLL
  // ============================================================

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) {
        return;
      }

      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    socket.disconnect();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

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
                      controller: scrollController,
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

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    final bool hasNearbyUsers = nearbyUsers.isNotEmpty;

    late String statusText;
    late Color statusColor;

    if (!esp32Connected) {
      statusText = "Connecting to SuChat...";
      statusColor = Colors.orange;
    } else if (hasNearbyUsers) {
      final int count = nearbyUsers.length;

      statusText = count == 1 ? "1 person nearby" : "$count people nearby";

      statusColor = Colors.green;
    } else {
      statusText = "Waiting for people nearby";
      statusColor = Colors.orange;
    }

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
          // MENU
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

          // LOGO
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: const Color(0xFF1565C0),
              borderRadius: BorderRadius.circular(14),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
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

          // TITLE
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
                        color: statusColor,
                      ),
                    ),

                    const SizedBox(width: 6),

                    Flexible(
                      child: Text(
                        statusText,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // USER AVATAR
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

  // ============================================================
  // DRAWER
  // ============================================================

  Widget _buildDrawer() {
    final String letter = widget.username.isNotEmpty
        ? widget.username[0].toUpperCase()
        : "?";

    final bool hasUsers = nearbyUsers.isNotEmpty;

    return Drawer(
      backgroundColor: const Color(0xFFF7F9FC),

      child: SafeArea(
        child: Column(
          children: [
            // ====================================================
            // PROFILE
            // ====================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(22, 30, 22, 27),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0D47A1),
                    Color(0xFF1976D2),
                    Color(0xFF42A5F5),
                  ],
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
                      letter,
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
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    widget.username,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: hasUsers
                              ? Colors.greenAccent
                              : Colors.orangeAccent,
                        ),
                      ),

                      const SizedBox(width: 7),

                      Text(
                        hasUsers
                            ? "${nearbyUsers.length} nearby"
                            : "No nearby users",
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

            _drawerSection("MESSAGING"),

            // PERSONAL
            _drawerItem(
              icon: Icons.person_rounded,
              title: "Personal Chats",
              subtitle: "Private conversations",
              color: const Color(0xFF1565C0),
              onTap: openPersonalChats,
            ),

            // GROUPS
            _drawerItem(
              icon: Icons.groups_rounded,
              title: "Groups",
              subtitle: "Group conversations",
              color: Colors.deepPurple,
              onTap: () {
                comingSoon("Groups", Icons.groups_rounded);
              },
            ),

            // EVERYONE
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

            _drawerSection("COMMUNICATION"),

            // LOCATION
            _drawerItem(
              icon: Icons.location_on_rounded,
              title: "Location",
              subtitle: "Share GPS location",
              color: Colors.red,
              onTap: () {
                comingSoon("Location", Icons.location_on_rounded);
              },
            ),

            // CALLING
            _drawerItem(
              icon: Icons.call_rounded,
              title: "Wi-Fi Calling",
              subtitle: "Local voice calls",
              color: Colors.green,
              onTap: () {
                comingSoon("Wi-Fi Calling", Icons.call_rounded);
              },
            ),

            const Spacer(),

            const Divider(indent: 20, endIndent: 20),

            // SETTINGS
            _drawerItem(
              icon: Icons.settings_rounded,
              title: "Settings",
              subtitle: "App settings",
              color: Colors.grey.shade700,
              onTap: () {
                comingSoon("Settings", Icons.settings_rounded);
              },
            ),

            const SizedBox(height: 12),

            const Text(
              "SuChat • Local Communication",
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DRAWER SECTION
  // ============================================================

  Widget _drawerSection(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 7, 22, 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DRAWER ITEM
  // ============================================================

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY CHAT
  // ============================================================

  Widget _buildEmptyChat() {
    final bool hasUsers = nearbyUsers.isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                hasUsers
                    ? Icons.chat_bubble_outline_rounded
                    : Icons.wifi_find_rounded,
                size: 45,
                color: const Color(0xFF1565C0),
              ),
            ),

            const SizedBox(height: 22),

            Text(
              hasUsers ? "Everyone Chat" : "Waiting for nearby users",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 9),

            Text(
              hasUsers
                  ? "You can now communicate with\n"
                        "people connected to SuChat."
                  : "Connect another phone to the\n"
                        "SuChat Wi-Fi network to start chatting.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: hasUsers
                    ? Colors.green.withValues(alpha: 0.08)
                    : Colors.orange.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    hasUsers
                        ? Icons.people_rounded
                        : Icons.person_search_rounded,
                    size: 18,
                    color: hasUsers
                        ? Colors.green.shade700
                        : Colors.orange.shade700,
                  ),

                  const SizedBox(width: 7),

                  Text(
                    hasUsers ? "${nearbyUsers.length} nearby" : "Waiting...",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: hasUsers
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
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

  // ============================================================
  // MESSAGE COMPOSER
  // ============================================================

  Widget _buildComposer() {
    final bool canSend = esp32Connected && nearbyUsers.isNotEmpty;

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
          // ADD BUTTON
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3F6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(
              onPressed: () {
                _showMessage(
                  "Attachments coming soon",
                  icon: Icons.attach_file_rounded,
                );
              },
              icon: const Icon(Icons.add_rounded),
            ),
          ),

          const SizedBox(width: 8),

          // TEXT FIELD
          Expanded(
            child: TextField(
              controller: messageController,
              minLines: 1,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: canSend
                    ? "Message everyone..."
                    : "Waiting for people...",

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
                if (canSend) {
                  sendMessage();
                }
              },
            ),
          ),

          const SizedBox(width: 8),

          // SEND BUTTON
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: canSend ? const Color(0xFF1565C0) : Colors.grey.shade400,
              borderRadius: BorderRadius.circular(16),
            ),
            child: IconButton(
              onPressed: canSend ? sendMessage : null,
              icon: const Icon(Icons.send_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
