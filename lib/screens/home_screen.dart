import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'personal_chats_screen.dart';

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
      duration: const Duration(milliseconds: 700),
    );

    fadeAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    );

    slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(
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

  String get firstLetter {
    if (widget.username.isEmpty) return "?";
    return widget.username[0].toUpperCase();
  }

  // ============================================================
  // EVERYONE CHAT
  // ============================================================

  void openEveryoneChat() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ChatScreen(username: widget.username)),
    );
  }

  // ============================================================
  // PERSONAL CHAT
  // ============================================================

  void openPersonalChats() {
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

  void comingSoon(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text("$name will be available soon"),
      ),
    );
  }

  // ============================================================
  // DRAWER
  // ============================================================

  Widget buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFFF7F9FC),
      child: SafeArea(
        child: Column(
          children: [
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
                            const Text(
                              "Your profile",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 3),
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
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.wifi_rounded, color: Colors.white, size: 17),
                        SizedBox(width: 8),
                        Text(
                          "Local SuChat network",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            _drawerTitle("MESSAGING"),

            _drawerItem(
              icon: Icons.forum_rounded,
              title: "Everyone",
              subtitle: "Chat with everyone nearby",
              onTap: () {
                Navigator.pop(context);
                openEveryoneChat();
              },
            ),

            _drawerItem(
              icon: Icons.person_rounded,
              title: "Personal Chat",
              subtitle: "Private conversations",
              onTap: () {
                Navigator.pop(context);
                openPersonalChats();
              },
            ),

            const Divider(height: 30, indent: 20, endIndent: 20),

            _drawerTitle("COMMUNICATION"),

            _drawerItem(
              icon: Icons.location_on_rounded,
              title: "Location",
              subtitle: "Share your GPS location",
              iconColor: Colors.red,
              onTap: () {
                Navigator.pop(context);
                comingSoon("Location");
              },
            ),

            _drawerItem(
              icon: Icons.call_rounded,
              title: "Wi-Fi Calling",
              subtitle: "Call over local Wi-Fi",
              iconColor: Colors.green,
              onTap: () {
                Navigator.pop(context);
                comingSoon("Wi-Fi Calling");
              },
            ),

            const Spacer(),

            const Divider(indent: 20, endIndent: 20),

            _drawerItem(
              icon: Icons.settings_rounded,
              title: "Settings",
              subtitle: "App and network settings",
              iconColor: Colors.grey,
              onTap: () {
                Navigator.pop(context);
                comingSoon("Settings");
              },
            ),

            const SizedBox(height: 12),

            const Text(
              "SuChat • Private local communication",
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _drawerTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 6),
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
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(14),
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
                Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
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
      drawer: buildDrawer(),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.forum_rounded),
            SizedBox(width: 10),
            Text("SuChat", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => comingSoon("Settings"),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),

      body: FadeTransition(
        opacity: fadeAnimation,
        child: SlideTransition(
          position: slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================================================
                // PROFILE
                // ==================================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1565C0).withValues(alpha: 0.22),
                        blurRadius: 22,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
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
                            const Text(
                              "Welcome to SuChat",
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
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 7),
                            const Row(
                              children: [
                                CircleAvatar(
                                  radius: 4,
                                  backgroundColor: Colors.greenAccent,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "Local network ready",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  "Messages",
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 5),

                Text(
                  "Choose how you want to communicate",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),

                const SizedBox(height: 16),

                // ==================================================
                // EVERYONE
                // ==================================================
                _featureCard(
                  icon: Icons.forum_rounded,
                  title: "Everyone",
                  subtitle: "Chat with everyone connected nearby",
                  iconColor: const Color(0xFF1565C0),
                  onTap: openEveryoneChat,
                  large: true,
                ),

                const SizedBox(height: 12),

                // ==================================================
                // PERSONAL
                // ==================================================
                _featureCard(
                  icon: Icons.person_rounded,
                  title: "Personal Chat",
                  subtitle: "Have a private conversation with someone",
                  iconColor: const Color(0xFF00897B),
                  onTap: openPersonalChats,
                  large: true,
                ),

                const SizedBox(height: 28),

                const Text(
                  "More",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 14),

                // ==================================================
                // LOCATION
                // ==================================================
                _featureCard(
                  icon: Icons.location_on_rounded,
                  title: "Location",
                  subtitle: "Share your GPS location",
                  iconColor: Colors.red,
                  onTap: () => comingSoon("Location"),
                ),

                const SizedBox(height: 12),

                // ==================================================
                // CALLING
                // ==================================================
                _featureCard(
                  icon: Icons.call_rounded,
                  title: "Wi-Fi Calling",
                  subtitle: "Voice calls over the local network",
                  iconColor: Colors.green,
                  onTap: () => comingSoon("Wi-Fi Calling"),
                ),

                const SizedBox(height: 28),

                // ==================================================
                // NETWORK
                // ==================================================
                Container(
                  width: double.infinity,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.wifi_rounded, color: Color(0xFF1565C0)),
                          SizedBox(width: 10),
                          Text(
                            "Local Network",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      _networkRow(
                        Icons.wifi_rounded,
                        "Connection",
                        "Local Wi-Fi",
                      ),

                      const SizedBox(height: 11),

                      _networkRow(Icons.memory_rounded, "ESP32", "192.168.4.1"),

                      const SizedBox(height: 11),

                      _networkRow(
                        Icons.lock_outline_rounded,
                        "Privacy",
                        "Local only",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                const Center(
                  child: Text(
                    "SuChat • Private local communication",
                    style: TextStyle(color: Colors.grey, fontSize: 11),
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

  Widget _featureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required VoidCallback onTap,
    bool large = false,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: EdgeInsets.all(large ? 18 : 16),
          child: Row(
            children: [
              Container(
                width: large ? 58 : 52,
                height: large ? 58 : 52,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: iconColor, size: large ? 29 : 25),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: large ? 17 : 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: Colors.grey.shade400,
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
        Icon(icon, size: 19, color: Colors.grey.shade600),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            title,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
        ),

        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ],
    );
  }
}
