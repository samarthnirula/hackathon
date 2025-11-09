import 'package:flutter/material.dart';
import 'nemotron_api.dart';
import 'crypto_price.dart';
import 'crypto_news.dart';
import 'home.dart';
import 'profile.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _messages = [
    {
      'text':
          '👋 Hello! I’m StockBot AI — your personal trading assistant. Ask for any crypto price, news, or analysis!',
      'isUser': false,
    }
  ];

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 300,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // *******************************************
  // MAIN INTELLIGENT MESSAGE HANDLER
  // *******************************************
  Future<String> _handleUserMessage(String text) async {
    final lower = text.toLowerCase();

    // ---------------- PRICE REQUEST ----------------
    if (lower.contains("price") || lower.contains("how much")) {
      final price = await CryptoPrice.getPriceFromSentence(text);

      if (price != null) {
        return "💰 The current price is **\$$price USD**.";
      } else {
        return "❌ I couldn't find that coin on CoinGecko.";
      }
    }

    // ---------------- NEWS REQUEST ----------------
    if (lower.contains("news") || lower.contains("headline")) {
      final news = await CryptoNews.getNews(text);

      if (news.isNotEmpty) {
        return "📰 **Latest News:**\n\n${news.map((e) => "• $e").join("\n")}";
      } else {
        return "No major news found for that crypto.";
      }
    }

    // ---------------- AI ANALYSIS ----------------
    if (lower.contains("analyze") ||
        lower.contains("analysis") ||
        lower.contains("should i buy")) {
      final price = await CryptoPrice.getPriceFromSentence(text) ?? 0;
      final news = await CryptoNews.getNews(text);

      final prompt = """
Give a detailed professional analysis for the cryptocurrency mentioned in this message.

User message: "$text"

Current Price: $price USD

Top News:
${news.isNotEmpty ? news.map((e) => "- $e").join("\n") : "No major news"}

Provide a detailed analysis including:
- Trend summary
- Short-term outlook
- Long-term outlook
- Risk level
- A Buy / Sell / Hold recommendation
""";

      String buffer = "";
      await for (final token in FinAI.streamChat(prompt)) {
        buffer += token;
      }
      return buffer;
    }

    // ---------------- DEFAULT → Nemotron Chat ----------------
    String buffer = "";
    await for (final token in FinAI.streamChat(text)) {
      buffer += token;
    }
    return buffer;
  }

  // *******************************************
  // SEND MESSAGE HANDLER
  // *******************************************
  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();

    setState(() {
      _messages.add({'text': text, 'isUser': true});
    });
    _scrollToBottom();

    final idx = _messages.length;
    setState(() {
      _messages.add({'text': "", 'isUser': false});
    });

    final reply = await _handleUserMessage(text);

    setState(() {
      _messages[idx]['text'] = reply;
    });

    _scrollToBottom();
  }

  void _onFooterTap(int idx) {
    if (idx == 1) return;

    switch (idx) {
      case 0:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomePage()));
        break;

      case 2:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ChatPage()));
        break;

      case 3:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ProfilePage()));
        break;
    }
  }

  // *******************************************
  // UI LAYOUT
  // *******************************************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),

      appBar: AppBar(
        title: const Text("StockBot AI"),
        backgroundColor: const Color(0xFF0A0A0A),
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [
          // ---------------- CHAT LIST ----------------
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['isUser'];

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isUser
                          ? const Color(0xFFB4D84C)
                          : const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      msg['text'],
                      style: TextStyle(
                        color: isUser ? Colors.black : Colors.white,
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // ---------------- INPUT BAR ----------------
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            color: const Color(0xFF0A0A0A),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF1A1A1A),
                      hintText: "Ask about any crypto...",
                      hintStyle: const TextStyle(color: Color(0xFF888888)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB4D84C),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.send, color: Colors.black),
                  ),
                )
              ],
            ),
          ),
        ],
      ),

      // ---------------- FOOTER NAV ----------------
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepPurple.shade900,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey.shade500,
        currentIndex: 1,
        onTap: _onFooterTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(
              icon: Icon(Icons.swap_horiz), label: "Transact"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
