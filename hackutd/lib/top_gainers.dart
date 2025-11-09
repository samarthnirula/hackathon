// lib/top_gainers.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_config.dart';

class TopGainersPage extends StatefulWidget {
  const TopGainersPage({super.key});

  @override
  State<TopGainersPage> createState() => _TopGainersPageState();
}

class _TopGainersPageState extends State<TopGainersPage> {
  List<dynamic> _gainers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchTopGainers();
  }

  Future<void> fetchTopGainers() async {
    try {
      final url =
          '${ApiConfig.baseUrl}/coins/markets?vs_currency=usd&order=percent_change_24h_desc&per_page=10&page=1&sparkline=false';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          _gainers = jsonDecode(response.body);
          _loading = false;
        });
      } else {
        throw Exception('Failed to load gainers');
      }
    } catch (e) {
      setState(() => _loading = false);
      debugPrint('⚠️ Error fetching gainers: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Top Crypto Gainers (24h)',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFB4D84C)))
          : RefreshIndicator(
              onRefresh: fetchTopGainers,
              color: const Color(0xFFB4D84C),
              child: ListView.builder(
                itemCount: _gainers.length,
                itemBuilder: (context, index) {
                  final coin = _gainers[index];
                  final priceChange =
                      (coin['price_change_percentage_24h'] ?? 0).toDouble();
                  final color =
                      priceChange >= 0 ? Colors.greenAccent : Colors.redAccent;

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(coin['image']),
                      backgroundColor: Colors.transparent,
                    ),
                    title: Text(
                      '${coin['name']} (${coin['symbol'].toUpperCase()})',
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      '\$${coin['current_price'].toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: Text(
                      '${priceChange.toStringAsFixed(2)}%',
                      style: TextStyle(
                          color: color, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
