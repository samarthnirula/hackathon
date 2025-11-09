import 'package:flutter/material.dart';
import 'home.dart';
import 'chat.dart';
import 'profile.dart';

/// Reusable header + bottom navigation bar
class HeaderFooter extends StatefulWidget {
  final String title;
  final Widget body;
  final int currentIndex; // highlight current tab

  const HeaderFooter({
    super.key,
    required this.title,
    required this.body,
    this.currentIndex = 0,
  });

  @override
  State<HeaderFooter> createState() => _HeaderFooterState();
}

class _HeaderFooterState extends State<HeaderFooter> {
  void _onItemTapped(int index) {
    if (index == widget.currentIndex) return;

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ChatPage()), // transactions temp
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProfilePage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),

      // 🔥 This ensures the footer is ALWAYS at the bottom
      body: Column(
        children: [
          Expanded(
            child: widget.body, // main content fills space above footer
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepPurple.shade900,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey.shade400,
        currentIndex: widget.currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz_rounded),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
