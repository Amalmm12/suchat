import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketChannel? _channel;

  bool get isConnected => _channel != null;

  void connect(String ip) {
    _channel = WebSocketChannel.connect(Uri.parse('ws://$ip:81'));
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }

  void sendMessage(String message) {
    if (_channel == null) return;

    final data = {"type": "chat", "text": message};

    _channel!.sink.add(jsonEncode(data));
  }

  Stream get messages => _channel!.stream;
}
