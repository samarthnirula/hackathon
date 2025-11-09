import 'dart:convert';
import 'package:http/http.dart' as http;

class CryptoNews {
  static List<String> extractKeywords(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r"[^\w\s]"), "")
        .split(" ")
        .where((w) => w.length >= 2)
        .toList();
  }

  static Future<String?> findCoinName(String keyword) async {
    final url = Uri.parse(
        "https://api.coingecko.com/api/v3/search?query=$keyword");

    final res = await http.get(url);
    if (res.statusCode != 200) return null;

    final data = jsonDecode(res.body);
    final coins = data["coins"];

    if (coins == null || coins.isEmpty) return null;

    return coins[0]["name"];
  }

  static Future<List<String>> getNews(String text) async {
    final keywords = extractKeywords(text);

    for (final word in keywords) {
      final coinName = await findCoinName(word);
      if (coinName == null) continue;

      final url = Uri.parse(
        "https://cryptopanic.com/api/v1/posts/?q=$coinName",
      );

      final res = await http.get(url);
      if (res.statusCode != 200) continue;

      final data = jsonDecode(res.body);
      if (data["results"] == null) continue;

      final posts = data["results"];

      final headlines = posts
          .map<String>((p) => p["title"] ?? "")
          .where((t) => t.isNotEmpty)
          .toList();

      if (headlines.isNotEmpty) {
        return headlines;
      }
    }

    return [];
  }
}
