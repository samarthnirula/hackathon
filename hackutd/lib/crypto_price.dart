import 'dart:convert';
import 'package:http/http.dart' as http;

class CryptoPrice {
  static List<String> extractKeywords(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r"[^\w\s]"), "")
        .split(" ")
        .where((w) => w.length >= 2)
        .toList();
  }

  static Future<String?> findCoinId(String keyword) async {
    final url = Uri.parse(
        "https://api.coingecko.com/api/v3/search?query=$keyword");

    final res = await http.get(url);
    if (res.statusCode != 200) return null;

    final data = jsonDecode(res.body);
    final coins = data["coins"];

    if (coins == null || coins.isEmpty) return null;

    return coins[0]["id"];
  }

  static Future<double?> getPriceFromSentence(String text) async {
    final keywords = extractKeywords(text);

    for (final word in keywords) {
      final id = await findCoinId(word);
      if (id == null) continue;

      final url = Uri.parse(
        "https://api.coingecko.com/api/v3/simple/price?ids=$id&vs_currencies=usd",
      );

      final res = await http.get(url);
      if (res.statusCode != 200) continue;

      final data = jsonDecode(res.body);

      if (data[id] != null && data[id]["usd"] != null) {
        return data[id]["usd"] * 1.0;
      }
    }

    return null;
  }
}
