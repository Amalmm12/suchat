import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketChannel? _channel;

  static const String serverUrl = "ws://192.168.4.1/ws";

  // ============================================================
  // CONNECT
  // ============================================================

  void connect({required String username}) {
    disconnect();

    try {
      _channel = WebSocketChannel.connect(Uri.parse(serverUrl));

      print("Connected to SuChat ESP32");

      // Tell ESP32 who we are.
      final joinMessage = {"type": "join", "username": username};

      _channel!.sink.add(jsonEncode(joinMessage));

      print("Joined as: $username");
    } catch (e) {
      print("WebSocket connection failed: $e");
    }
  }

  // ============================================================
  // SEND EVERYONE MESSAGE
  // ============================================================

  void send({required String sender, required String text}) {
    if (_channel == null) {
      print("WebSocket not connected");
      return;
    }

    final message = {
      "type": "message",
      "sender": sender,
      "text": text,
      "time": DateTime.now().millisecondsSinceEpoch,
    };

    final encoded = jsonEncode(message);

    _channel!.sink.add(encoded);

    print("Sending everyone message: $encoded");
  }

  // ============================================================
  // SEND PERSONAL MESSAGE
  // ============================================================

  void sendPersonalMessage({
    required String sender,
    required String receiver,
    required String text,
  }) {
    if (_channel == null) {
      print("WebSocket not connected");
      return;
    }

    final message = {
      "type": "personal",
      "sender": sender,
      "receiver": receiver,
      "text": text,
      "time": DateTime.now().millisecondsSinceEpoch,
    };

    final encoded = jsonEncode(message);

    _channel!.sink.add(encoded);

    print("Sending personal message: $encoded");
  }

  // ============================================================
  // DECODE MESSAGE
  // ============================================================

  Map<String, dynamic> decodeMessage(dynamic data) {
    try {
      if (data is String) {
        final decoded = jsonDecode(data);

        if (decoded is Map<String, dynamic>) {
          return decoded;
        }

        if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        }
      }

      return {};
    } catch (e) {
      print("JSON decode error: $e");
      return {};
    }
  }

  // ============================================================
  // STREAM
  // ============================================================

  Stream<dynamic> get stream {
    if (_channel == null) {
      throw Exception("WebSocket is not connected.");
    }

    return _channel!.stream;
  }

  // ============================================================
  // CONNECTION STATUS
  // ============================================================

  bool get isConnected {
    return _channel != null;
  }

  // ============================================================
  // DISCONNECT
  // ============================================================

  void disconnect() {
    try {
      _channel?.sink.close();
    } catch (_) {}

    _channel = null;

    print("Disconnected from SuChat ESP32");
  }
}
