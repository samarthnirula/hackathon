import 'package:flutter/material.dart';
import 'header_footer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return HeaderFooter(
      title: 'Home Page',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.home, size: 60, color: Colors.deepPurple),
            SizedBox(height: 16),
            Text(
              '🎉 Welcome to Home Page!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
