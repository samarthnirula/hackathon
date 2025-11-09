// lib/eventsource.dart

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SSEClient {
  static Stream<String> connect({
    required String url,
    required Map<String, String> headers,
    required Map body,
  }) async* {
    final request = http.Request("POST", Uri.parse(url));
    request.headers.addAll(headers);
    request.body = jsonEncode(body);

    final streamed = await request.send();

    final stream = streamed.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    await for (final line in stream) {
      if (line.startsWith("data:")) {
        final data = line.substring(5).trim();

        if (data == "[DONE]") break;

        yield data;
      }
    }
  }
}
