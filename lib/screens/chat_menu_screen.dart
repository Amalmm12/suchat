import 'package:flutter/material.dart';

import 'chat_screen.dart';
import 'personal_chats_screen.dart';

class ChatMenuScreen extends StatelessWidget {
  final String username;

  const ChatMenuScreen({super.key, required this.username});

  // ============================================================
  // PERSONAL CHATS
  // ============================================================

  void openPersonalChats(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PersonalChatsScreen(username: username),
      ),
    );
  }

  // ============================================================
  // EVERYONE
  // ============================================================

  void openEveryone(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ChatScreen(username: username)),
    );
  }

  // ============================================================
  // COMING SOON
  // ============================================================

  void comingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text("$feature will be available soon"),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      drawer: _buildDrawer(context),

      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF17202A),
        elevation: 0,
        surfaceTintColor: Colors.transparent,

        title: const Row(
          children: [
            Icon(Icons.forum_rounded, color: Color(0xFF1565C0), size: 24),
            SizedBox(width: 10),
            Text(
              "Chats",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
          children: [
            // ======================================================
            // HEADER
            // ======================================================
            const Text(
              "Start a conversation",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text(
              "Choose who you want to message on your local network.",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),

            const SizedBox(height: 22),

            // ======================================================
            // PERSONAL
            // ======================================================
            _chatOption(
              context,
              icon: Icons.person_rounded,
              iconColor: const Color(0xFF1565C0),
              title: "Personal Chats",
              subtitle: "Chat privately with one person",
              badge: "PRIVATE",
              onTap: () => openPersonalChats(context),
            ),

            const SizedBox(height: 14),

            // ======================================================
            // GROUPS
            // ======================================================
            _chatOption(
              context,
              icon: Icons.groups_rounded,
              iconColor: const Color(0xFF6A1B9A),
              title: "Groups",
              subtitle: "Chat with multiple people",
              badge: "GROUP",
              onTap: () => comingSoon(context, "Groups"),
            ),

            const SizedBox(height: 14),

            // ======================================================
            // EVERYONE
            // ======================================================
            _chatOption(
              context,
              icon: Icons.campaign_rounded,
              iconColor: const Color(0xFFEF6C00),
              title: "Everyone",
              subtitle: "Send a message to everyone nearby",
              badge: "BROADCAST",
              onTap: () => openEveryone(context),
            ),

            const SizedBox(height: 28),

            // ======================================================
            // NETWORK INFO
            // ======================================================
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.wifi_rounded,
                      color: Color(0xFF2E7D32),
                    ),
                  ),

                  const SizedBox(width: 13),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Local network",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          "Messages stay on your SuChat network",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.lock_rounded,
                    size: 19,
                    color: Color(0xFF2E7D32),
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
  // DRAWER
  // ============================================================

  Widget _buildDrawer(BuildContext context) {
    final letter = username.isNotEmpty ? username[0].toUpperCase() : "?";

    return Drawer(
      backgroundColor: const Color(0xFFF7F9FC),
      child: SafeArea(
        child: Column(
          children: [
            // ====================================================
            // PROFILE HEADER
            // ====================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(22, 30, 22, 28),
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

                  const SizedBox(height: 13),

                  const Text(
                    "SuChat",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    username,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 4,
                          backgroundColor: Colors.greenAccent,
                        ),
                        SizedBox(width: 7),
                        Text(
                          "Local network",
                          style: TextStyle(color: Colors.white, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            _drawerSection("MESSAGING"),

            _drawerItem(
              icon: Icons.person_rounded,
              title: "Personal Chats",
              subtitle: "Private conversations",
              color: const Color(0xFF1565C0),
              onTap: () {
                Navigator.pop(context);
                openPersonalChats(context);
              },
            ),

            _drawerItem(
              icon: Icons.groups_rounded,
              title: "Groups",
              subtitle: "Group conversations",
              color: const Color(0xFF6A1B9A),
              onTap: () {
                Navigator.pop(context);
                comingSoon(context, "Groups");
              },
            ),

            _drawerItem(
              icon: Icons.campaign_rounded,
              title: "Everyone",
              subtitle: "Message everyone nearby",
              color: const Color(0xFFEF6C00),
              onTap: () {
                Navigator.pop(context);
                openEveryone(context);
              },
            ),

            const Divider(height: 28, indent: 20, endIndent: 20),

            _drawerSection("COMMUNICATION"),

            // ====================================================
            // LOCATION — LATER
            // ====================================================
            _drawerItem(
              icon: Icons.location_on_rounded,
              title: "Location",
              subtitle: "Share your location",
              color: Colors.red,
              onTap: () {
                Navigator.pop(context);
                comingSoon(context, "Location");
              },
            ),

            // ====================================================
            // CALLING — LATER
            // ====================================================
            _drawerItem(
              icon: Icons.call_rounded,
              title: "Wi-Fi Calling",
              subtitle: "Local voice calls",
              color: Colors.green,
              onTap: () {
                Navigator.pop(context);
                comingSoon(context, "Wi-Fi Calling");
              },
            ),

            const Spacer(),

            const Divider(indent: 20, endIndent: 20),

            _drawerItem(
              icon: Icons.settings_rounded,
              title: "Settings",
              subtitle: "App settings",
              color: Colors.grey.shade700,
              onTap: () {
                Navigator.pop(context);
                comingSoon(context, "Settings");
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
  // CHAT OPTION
  // ============================================================

  Widget _chatOption(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String badge,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: iconColor, size: 29),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        badge,
                        style: TextStyle(
                          color: iconColor,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
