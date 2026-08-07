import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketChannel? _channel;

  /// Connect to ESP32 WebSocket server
  void connect() {
    try {
      _channel = WebSocketChannel.connect(Uri.parse("ws://192.168.4.1/ws"));

      print("Connected to ESP32 WebSocket");
    } catch (e) {
      print("Connection Failed: $e");
    }
  }

  /// Disconnect
  void disconnect() {
    _channel?.sink.close();
    _channel = null;

    print("Disconnected");
  }

  /// Send a message
  void send({required String sender, required String text}) {
    if (_channel == null) {
      print("WebSocket not connected");
      return;
    }

    final message = {
      "sender": sender,
      "text": text,
      "time": DateTime.now().millisecondsSinceEpoch,
    };

    final jsonMessage = jsonEncode(message);

    print("Sending: $jsonMessage");

    _channel!.sink.add(jsonMessage);
  }

  /// Incoming message stream
  Stream<dynamic> get stream {
    if (_channel == null) {
      throw Exception("WebSocket is not connected.");
    }

    return _channel!.stream;
  }

  /// Check connection
  bool get isConnected => _channel != null;
}
