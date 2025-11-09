// lib/nemotron_api.dart

import 'dart:convert';
import 'package:hackutd/eventsource.dart';

class FinAI {
  static const String _apiUrl =
      "https://integrate.api.nvidia.com/v1/chat/completions";

  static const String _model = "nvidia/nemotron-nano-9b-v2";

  static const String _apiKey =
      "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";

  static Stream<String> streamChat(String userMessage) async* {
    final stream = SSEClient.connect(
      url: _apiUrl,
      headers: {
        "Authorization": "Bearer $_apiKey",
        "Content-Type": "application/json",
        "Accept": "text/event-stream",
      },
      body: {
        "model": _model,
        "stream": true,
        "messages": [
          {"role": "user", "content": userMessage}
        ],
      },
    );

    await for (final raw in stream) {
      try {
        final decoded = jsonDecode(raw);
        final delta = decoded["choices"][0]["delta"];
        if (delta?["content"] != null) yield delta["content"];
      } catch (_) {}
    }
  }
}
