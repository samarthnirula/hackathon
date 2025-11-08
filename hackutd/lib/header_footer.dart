import 'package:flutter/material.dart';

/// A simple reusable header and footer widget
class HeaderFooter extends StatelessWidget {
  final String title;
  final Widget body;

  const HeaderFooter({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: body,
      bottomNavigationBar: Container(
        color: Colors.deepPurple.shade100,
        padding: const EdgeInsets.all(12),
        child: const Center(
          child: Text(
            '© 2025 My Flutter App',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
