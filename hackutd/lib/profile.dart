import 'package:flutter/material.dart';
import 'home.dart';
import 'chat.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Footer Navigation
  void _onFooterTap(BuildContext context, int index) {
    if (index == 3) return; // already on Profile

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ChatPage()),
        );
        break;
      case 2:
        // TEMP: transactions = chat page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ChatPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),

      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            // Avatar
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),

            const SizedBox(height: 20),

            // Username
            const Text(
              "Saakin User",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Email
            Text(
              "saakin@example.com",
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 30),

            // Options
            _profileTile(Icons.settings, "Account Settings"),
            _profileTile(Icons.lock_outline, "Privacy & Security"),
            _profileTile(Icons.notifications_none, "Notifications"),
            _profileTile(Icons.help_outline, "Help & Support"),
            _profileTile(Icons.logout, "Logout", isDanger: true),
          ],
        ),
      ),

      // ⭐ FOOTER NAVIGATION ⭐
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepPurple.shade900,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey.shade400,
        currentIndex: 3,
        onTap: (i) => _onFooterTap(context, i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline_rounded), label: "Chat"),
          BottomNavigationBarItem(
              icon: Icon(Icons.swap_horiz_rounded), label: "Transactions"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded), label: "Profile"),
        ],
      ),
    );
  }

  Widget _profileTile(IconData icon, String title, {bool isDanger = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF222222)),
      ),
      child: Row(
        children: [
          Icon(icon, color: isDanger ? Colors.red : Colors.greenAccent),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: isDanger ? Colors.red : Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
        ],
      ),
    );
  }
}
