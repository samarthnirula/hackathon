import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'chat.dart';
import 'profile.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StockBot AI',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF000000),
        fontFamily: 'Inter',
      ),
      debugShowCheckedModeBanner: false,
      home: const StockBotHomePage(),
    );
  }
}

class StockBotHomePage extends StatefulWidget {
  const StockBotHomePage({Key? key}) : super(key: key);

  @override
  State<StockBotHomePage> createState() => _StockBotHomePageState();
}

class _StockBotHomePageState extends State<StockBotHomePage> {
  List<dynamic> _topGainers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchTopGainers();
  }

  Future<void> fetchTopGainers() async {
    try {
      final url =
          'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=percent_change_24h_desc&per_page=5&page=1&sparkline=false';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          _topGainers = jsonDecode(response.body);
          _loading = false;
        });
      } else {
        throw Exception('Failed to load top gainers');
      }
    } catch (e) {
      debugPrint('⚠️ Error: $e');
      setState(() => _loading = false);
    }
  }

  void _goToChat() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ChatPage()),
    );
  }

  void _goToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth < 400 ? 16.0 : 24.0;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 🔝 Top bar
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.show_chart,
                              color: Color(0xFFB4D84C), size: 28),
                          SizedBox(width: 8),
                          Text(
                            'StockBot AI',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: _goToChat,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB4D84C),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),

                // 🦸 Hero
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Color(0xFF2A2A2A)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          CircleAvatar(
                            radius: 4,
                            backgroundColor: Color(0xFFB4D84C),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'AI-Powered Stock Analysis',
                            style: TextStyle(
                              color: Color(0xFFAAAAAA),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            height: 1.2),
                        children: [
                          TextSpan(
                              text: 'Your AI Trading ',
                              style: TextStyle(color: Colors.white)),
                          TextSpan(
                              text: 'Assistant',
                              style: TextStyle(color: Color(0xFFB4D84C))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Get real-time market insights, personalized trading strategies, and 24/7 support from our advanced AI chatbot.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xFF888888),
                          fontSize: 16,
                          height: 1.5),
                    ),
                    const SizedBox(height: 40),

                    // Buttons
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: [
                        ElevatedButton(
                          onPressed: _goToChat,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB4D84C),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                          ),
                          child: const Text(
                            'Start Trading Smarter',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            side: const BorderSide(
                                color: Color(0xFF2A2A2A), width: 1),
                          ),
                          child: const Text(
                            'Watch Demo',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 80),

                // 📊 Stats
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: const [
                    _StatCard(value: '99.9%', label: 'Uptime'),
                    _StatCard(value: '50K+', label: 'Active Traders'),
                    _StatCard(value: '24/7', label: 'AI Support'),
                  ],
                ),

                const SizedBox(height: 80),

                // 💎 Features
                Wrap(
                  spacing: 24,
                  runSpacing: 24,
                  alignment: WrapAlignment.center,
                  children: const [
                    _FeatureCard(
                      icon: Icons.bar_chart,
                      title: 'Real-Time Analysis',
                      description:
                          'Get instant market insights and technical analysis powered by advanced AI algorithms.',
                    ),
                    _FeatureCard(
                      icon: Icons.chat_bubble_outline,
                      title: 'Smart Conversations',
                      description:
                          'Ask questions in natural language and get personalized trading recommendations.',
                    ),
                    _FeatureCard(
                      icon: Icons.shield_outlined,
                      title: 'Secure & Private',
                      description:
                          'Your data is encrypted and protected with enterprise-grade security measures.',
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                // 🚀 TOP GAINERS
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    '🔥 Top Crypto Gainers (24h)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                _loading
                    ? const CircularProgressIndicator(
                        color: Color(0xFFB4D84C),
                      )
                    : Column(
                        children: _topGainers.map((coin) {
                          final priceChange =
                              (coin['price_change_percentage_24h'] ?? 0)
                                  .toDouble();

                          final color = priceChange >= 0
                              ? Colors.greenAccent
                              : Colors.redAccent;

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF111111),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Color(0xFF222222)),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundImage:
                                      NetworkImage(coin['image']),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    '${coin['name']} (${coin['symbol'].toUpperCase()})',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Text(
                                  '${priceChange.toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),

                const SizedBox(height: 100), // spacing above footer
              ],
            ),
          ),
        ),
      ),

      // ⭐ FOOTER ADDED HERE ⭐
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepPurple.shade900,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey.shade400,
        currentIndex: 0,
        onTap: (i) {
          if (i == 0) return; // already on home
          if (i == 1) _goToChat();
          if (i == 2) _goToChat(); // transactions temp
          if (i == 3) _goToProfile();
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline), label: "Chat"),
          BottomNavigationBarItem(
              icon: Icon(Icons.swap_horiz_rounded), label: "Transactions"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded), label: "Profile"),
        ],
      ),
    );
  }
}

// 🔢 STAT CARD
class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF1A1A1A)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFB4D84C),
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
                color: Color(0xFF666666),
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

// ⚙ FEATURE CARD
class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  const _FeatureCard(
      {required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0A0A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFF1A1A1A)),
            ),
            child: Icon(icon, color: const Color(0xFFB4D84C), size: 24),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
                color: Color(0xFF888888),
                fontSize: 16,
                height: 1.5),
          ),
        ],
      ),
    );
  }
}
