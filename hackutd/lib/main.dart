import 'package:flutter/material.dart';
import 'package:hackutd/home.dart';
import 'firebase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.init(); // 👈 initialize Firebase before app starts
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trading With Friends',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
