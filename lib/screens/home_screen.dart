import 'package:flutter/material.dart';

import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    fadeAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    );

    slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  // ============================================================
  // OPEN GROUP CHAT
  // ============================================================

  void openGroupChat() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ChatScreen(username: widget.username)),
    );
  }

  // ============================================================
  // COMING SOON
  // ============================================================

  void showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Text("$feature is coming soon"),
      ),
    );
  }

  // ============================================================
  // DRAWER
  // ============================================================

  Widget buildDrawer() {
    final String firstLetter = widget.username.isNotEmpty
        ? widget.username[0].toUpperCase()
        : "?";

    return Drawer(
      backgroundColor: const Color(0xFFF7F9FC),
      child: SafeArea(
        child: Column(
          children: [
            // ----------------------------------------------------
            // PROFILE HEADER
            // ----------------------------------------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 25),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0D47A1),
                    Color(0xFF1565C0),
                    Color(0xFF42A5F5),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Text(
                          firstLetter,
                          style: const TextStyle(
                            color: Color(0xFF1565C0),
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.username,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 5),

                            const Row(
                              children: [
                                CircleAvatar(
                                  radius: 4,
                                  backgroundColor: Colors.greenAccent,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "Connected",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.wifi_rounded, color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text(
                          "Local Wi-Fi network",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ----------------------------------------------------
            // CHATS SECTION
            // ----------------------------------------------------
            _drawerSectionTitle("MESSAGING"),

            _drawerItem(
              icon: Icons.chat_rounded,
              title: "All Chats",
              subtitle: "View your conversations",
              onTap: () {
                Navigator.pop(context);
                openGroupChat();
              },
            ),

            _drawerItem(
              icon: Icons.groups_rounded,
              title: "Group Chat",
              subtitle: "Chat with everyone",
              onTap: () {
                Navigator.pop(context);
                openGroupChat();
              },
            ),

            _drawerItem(
              icon: Icons.person_rounded,
              title: "Personal Chat",
              subtitle: "Chat with one person",
              onTap: () {
                Navigator.pop(context);
                showPersonalChat();
              },
            ),

            const SizedBox(height: 8),

            const Divider(indent: 20, endIndent: 20),

            // ----------------------------------------------------
            // COMMUNICATION SECTION
            // ----------------------------------------------------
            _drawerSectionTitle("COMMUNICATION"),

            _drawerItem(
              icon: Icons.location_on_rounded,
              title: "Location",
              subtitle: "Share your GPS location",
              iconColor: Colors.red,
              onTap: () {
                Navigator.pop(context);
                showComingSoon("Location");
              },
            ),

            _drawerItem(
              icon: Icons.call_rounded,
              title: "Wi-Fi Calling",
              subtitle: "Call over local Wi-Fi",
              iconColor: Colors.green,
              onTap: () {
                Navigator.pop(context);
                showComingSoon("Wi-Fi Calling");
              },
            ),

            const Spacer(),

            const Divider(indent: 20, endIndent: 20),

            // ----------------------------------------------------
            // SETTINGS
            // ----------------------------------------------------
            _drawerItem(
              icon: Icons.settings_rounded,
              title: "Settings",
              subtitle: "App and network settings",
              iconColor: Colors.grey.shade700,
              onTap: () {
                Navigator.pop(context);
                showComingSoon("Settings");
              },
            ),

            const SizedBox(height: 8),

            const Text(
              "SuChat • Local communication",
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),

            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DRAWER SECTION TITLE
  // ============================================================

  Widget _drawerSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
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
    required VoidCallback onTap,
    Color iconColor = const Color(0xFF1565C0),
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
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
                    color: iconColor.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
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
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PERSONAL CHAT BOTTOM SHEET
  // ============================================================

  void showPersonalChat() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Personal Chat",
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 6),

                Text(
                  "Choose a person to start a private chat.",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),

                const SizedBox(height: 20),

                // Temporary users
                // We will replace these with
                // real ESP32 connected users later.
                _personTile(name: "Rahul", online: true),

                _personTile(name: "Alex", online: true),

                _personTile(name: "John", online: false),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // PERSON TILE
  // ============================================================

  Widget _personTile({required String name, required bool online}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFFE3F2FD),
            child: Text(
              name[0].toUpperCase(),
              style: const TextStyle(
                color: Color(0xFF1565C0),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          if (online)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 13,
                height: 13,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),

      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),

      subtitle: Text(
        online ? "Online" : "Offline",
        style: TextStyle(
          color: online ? Colors.green : Colors.grey,
          fontSize: 12,
        ),
      ),

      trailing: online
          ? const Icon(
              Icons.chat_bubble_outline_rounded,
              color: Color(0xFF1565C0),
            )
          : null,

      onTap: online
          ? () {
              Navigator.pop(context);

              showComingSoon("Private chat with $name");
            }
          : null,
    );
  }

  // ============================================================
  // MAIN SCREEN
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final String firstLetter = widget.username.isNotEmpty
        ? widget.username[0].toUpperCase()
        : "?";

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      // DRAWER
      drawer: buildDrawer(),

      // APP BAR
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,

        title: const Row(
          children: [
            Icon(Icons.chat_rounded),
            SizedBox(width: 10),
            Text("SuChat", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),

        actions: [
          IconButton(
            onPressed: () {
              showComingSoon("Settings");
            },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),

      // ========================================================
      // BODY
      // ========================================================
      body: FadeTransition(
        opacity: fadeAnimation,
        child: SlideTransition(
          position: slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ------------------------------------------------
                // PROFILE CARD
                // ------------------------------------------------
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1565C0).withOpacity(0.22),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 29,
                            backgroundColor: Colors.white,
                            child: Text(
                              firstLetter,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1565C0),
                              ),
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Welcome back",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
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
                              ],
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                CircleAvatar(
                                  radius: 4,
                                  backgroundColor: Colors.greenAccent,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "Online",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "You're connected to your local SuChat network.",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // ------------------------------------------------
                // COMMUNICATION
                // ------------------------------------------------
                const Text(
                  "Communication",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 14),

                _buildFeatureCard(
                  icon: Icons.chat_bubble_rounded,
                  title: "Chats",
                  subtitle: "Message devices on your network",
                  iconColor: const Color(0xFF1565C0),
                  onTap: openGroupChat,
                ),

                const SizedBox(height: 12),

                _buildFeatureCard(
                  icon: Icons.groups_rounded,
                  title: "Group Chat",
                  subtitle: "Chat with everyone connected",
                  iconColor: const Color(0xFF7B1FA2),
                  onTap: openGroupChat,
                ),

                const SizedBox(height: 12),

                _buildFeatureCard(
                  icon: Icons.person_rounded,
                  title: "Personal Chat",
                  subtitle: "Chat privately with one person",
                  iconColor: const Color(0xFF00897B),
                  onTap: showPersonalChat,
                ),

                const SizedBox(height: 12),

                _buildFeatureCard(
                  icon: Icons.location_on_rounded,
                  title: "Location",
                  subtitle: "Share your current GPS location",
                  iconColor: Colors.red,
                  onTap: () {
                    showComingSoon("Location");
                  },
                ),

                const SizedBox(height: 12),

                _buildFeatureCard(
                  icon: Icons.call_rounded,
                  title: "Wi-Fi Calling",
                  subtitle: "Make calls over local Wi-Fi",
                  iconColor: Colors.green,
                  onTap: () {
                    showComingSoon("Wi-Fi Calling");
                  },
                ),

                const SizedBox(height: 28),

                // ------------------------------------------------
                // OTHER
                // ------------------------------------------------
                const Text(
                  "Other",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 14),

                _buildFeatureCard(
                  icon: Icons.settings_rounded,
                  title: "Settings",
                  subtitle: "App and connection settings",
                  iconColor: Colors.grey.shade700,
                  onTap: () {
                    showComingSoon("Settings");
                  },
                ),

                const SizedBox(height: 28),

                // ------------------------------------------------
                // NETWORK CARD
                // ------------------------------------------------
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.wifi_rounded, color: Color(0xFF1565C0)),
                          SizedBox(width: 10),
                          Text(
                            "SuChat Network",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      _networkRow(Icons.wifi, "Connection", "Local Wi-Fi"),

                      const SizedBox(height: 10),

                      _networkRow(Icons.memory_rounded, "ESP32", "192.168.4.1"),

                      const SizedBox(height: 10),

                      _networkRow(
                        Icons.lock_outline_rounded,
                        "Network",
                        "Private",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                const Center(
                  child: Text(
                    "SuChat • Local communication",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // FEATURE CARD
  // ============================================================

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(icon, color: iconColor, size: 27),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // NETWORK ROW
  // ============================================================

  Widget _networkRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            title,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
        ),

        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ],
    );
  }
}
