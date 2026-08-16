import 'package:flutter/material.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();

  late AnimationController animationController;

  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;
  late Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    fadeAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    );

    scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOutBack),
    );

    slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
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
    nameController.dispose();
    super.dispose();
  }

  void continueToChat() {
    final name = nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 10),
              Text("Please enter your name"),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );

      return;
    }

    FocusScope.of(context).unfocus();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ChatScreen(username: name)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ─────────────────────────────────────
          // BACKGROUND
          // ─────────────────────────────────────
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0D47A1),
                  Color(0xFF1565C0),
                  Color(0xFF42A5F5),
                ],
              ),
            ),
          ),

          // ─────────────────────────────────────
          // DECORATIVE CIRCLES
          // ─────────────────────────────────────
          Positioned(
            top: -100,
            right: -80,
            child: _backgroundCircle(size: 260, opacity: 0.10),
          ),

          Positioned(
            bottom: -120,
            left: -100,
            child: _backgroundCircle(size: 300, opacity: 0.08),
          ),

          Positioned(
            top: 150,
            left: -60,
            child: _backgroundCircle(size: 130, opacity: 0.06),
          ),

          // ─────────────────────────────────────
          // CONTENT
          // ─────────────────────────────────────
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 30,
                ),
                child: FadeTransition(
                  opacity: fadeAnimation,
                  child: SlideTransition(
                    position: slideAnimation,
                    child: ScaleTransition(
                      scale: scaleAnimation,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 480),
                        child: Column(
                          children: [
                            // ─────────────────────────
                            // LOGO
                            // ─────────────────────────
                            Container(
                              width: 115,
                              height: 115,
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(32),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.20),
                                    blurRadius: 30,
                                    offset: const Offset(0, 15),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(26),
                                child: Image.asset(
                                  'assets/logo.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.chat_rounded,
                                      size: 60,
                                      color: Color(0xFF1565C0),
                                    );
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // ─────────────────────────
                            // APP NAME
                            // ─────────────────────────
                            const Text(
                              "SuChat",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                              ),
                            ),

                            const SizedBox(height: 8),

                            const Text(
                              "Private communication.\nAnywhere. Anytime.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                height: 1.4,
                              ),
                            ),

                            const SizedBox(height: 32),

                            // ─────────────────────────
                            // LOGIN CARD
                            // ─────────────────────────
                            Container(
                              padding: const EdgeInsets.all(26),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.18),
                                    blurRadius: 35,
                                    offset: const Offset(0, 18),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Welcome 👋",
                                    style: TextStyle(
                                      fontSize: 27,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF172033),
                                    ),
                                  ),

                                  const SizedBox(height: 7),

                                  Text(
                                    "Choose a name to join your local network.",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),

                                  const SizedBox(height: 25),

                                  // NAME LABEL
                                  const Text(
                                    "Your name",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF343A46),
                                    ),
                                  ),

                                  const SizedBox(height: 9),

                                  // NAME FIELD
                                  TextField(
                                    controller: nameController,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    textInputAction: TextInputAction.done,
                                    onSubmitted: (_) => continueToChat(),
                                    decoration: InputDecoration(
                                      hintText: "Enter your name",
                                      hintStyle: TextStyle(
                                        color: Colors.grey.shade500,
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.person_outline_rounded,
                                        color: Color(0xFF1565C0),
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFF5F7FB),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 18,
                                            vertical: 17,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF1565C0),
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // ─────────────────────
                                  // CONTINUE BUTTON
                                  // ─────────────────────
                                  SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: ElevatedButton(
                                      onPressed: continueToChat,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF1565C0,
                                        ),
                                        foregroundColor: Colors.white,
                                        elevation: 4,
                                        shadowColor: const Color(
                                          0xFF1565C0,
                                        ).withValues(alpha: 0.35),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Continue",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 21,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // ─────────────────────
                                  // NETWORK STATUS
                                  // ─────────────────────
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F8FF),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.wifi_rounded,
                                          size: 20,
                                          color: Color(0xFF1565C0),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            "Local Wi-Fi network",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF1565C0),
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.check_circle_rounded,
                                          size: 19,
                                          color: Colors.green,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 25),

                            // ─────────────────────────
                            // FOOTER
                            // ─────────────────────────
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.lock_outline_rounded,
                                  size: 15,
                                  color: Colors.white60,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "Private • Local • No Internet Required",
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
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _backgroundCircle({required double size, required double opacity}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }
}
