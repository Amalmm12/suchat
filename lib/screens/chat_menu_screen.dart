import 'package:flutter/material.dart';

class ChatMenuScreen extends StatelessWidget {
  final String username;

  const ChatMenuScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        title: const Text(
          "Chats",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      drawer: _buildDrawer(context),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _chatOption(
            context,
            icon: Icons.person_rounded,
            iconColor: const Color(0xFF1565C0),
            title: "Personal Chats",
            subtitle: "Chat privately with one person",
            onTap: () {
              Navigator.pop(context);
            },
          ),

          const SizedBox(height: 12),

          _chatOption(
            context,
            icon: Icons.groups_rounded,
            iconColor: Colors.deepPurple,
            title: "Groups",
            subtitle: "Chat with multiple people",
            onTap: () {
              Navigator.pop(context);
            },
          ),

          const SizedBox(height: 12),

          _chatOption(
            context,
            icon: Icons.campaign_rounded,
            iconColor: Colors.orange,
            title: "Everyone",
            subtitle: "Send a message to everyone",
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // ─────────────────────────
            // DRAWER HEADER
            // ─────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 25),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0D47A1), Color(0xFF42A5F5)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: Text(
                      username.isNotEmpty ? username[0].toUpperCase() : "?",
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

                  const SizedBox(height: 2),

                  Text(
                    username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Row(
                    children: [
                      Icon(
                        Icons.wifi_rounded,
                        size: 15,
                        color: Colors.greenAccent,
                      ),
                      SizedBox(width: 6),
                      Text(
                        "Local network",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ─────────────────────────
            // PERSONAL
            // ─────────────────────────
            _drawerItem(
              icon: Icons.person_rounded,
              title: "Personal Chats",
              subtitle: "Private conversations",
              color: const Color(0xFF1565C0),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            // ─────────────────────────
            // GROUPS
            // ─────────────────────────
            _drawerItem(
              icon: Icons.groups_rounded,
              title: "Groups",
              subtitle: "Group conversations",
              color: Colors.deepPurple,
              onTap: () {
                Navigator.pop(context);
              },
            ),

            // ─────────────────────────
            // EVERYONE
            // ─────────────────────────
            _drawerItem(
              icon: Icons.campaign_rounded,
              title: "Everyone",
              subtitle: "Broadcast to all devices",
              color: Colors.orange,
              onTap: () {
                Navigator.pop(context);
              },
            ),

            const Divider(height: 25, indent: 18, endIndent: 18),

            // ─────────────────────────
            // LOCATION
            // ─────────────────────────
            _drawerItem(
              icon: Icons.location_on_rounded,
              title: "Location",
              subtitle: "Share your location",
              color: Colors.red,
              onTap: () {
                Navigator.pop(context);
              },
            ),

            // ─────────────────────────
            // SETTINGS
            // ─────────────────────────
            _drawerItem(
              icon: Icons.settings_rounded,
              title: "Settings",
              subtitle: "App settings",
              color: Colors.grey.shade700,
              onTap: () {
                Navigator.pop(context);
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
      onTap: onTap,
    );
  }

  Widget _chatOption(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(icon, color: iconColor, size: 28),
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
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 17,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
