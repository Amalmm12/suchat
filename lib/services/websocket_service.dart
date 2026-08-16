import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketChannel? _channel;

  StreamSubscription? _subscription;

  String? _username;

  final StreamController<dynamic> _messageController =
      StreamController<dynamic>.broadcast();

  // ─────────────────────────────────────────────
  // CONNECTION
  // ─────────────────────────────────────────────

  void connect({required String username}) {
    if (_channel != null) {
      print("WebSocket already connected");
      return;
    }

    try {
      _username = username.trim();

      _channel = WebSocketChannel.connect(Uri.parse("ws://192.168.4.1/ws"));

      print("Connecting to ESP32...");
      print("Username: $_username");

      _subscription = _channel!.stream.listen(
        (data) {
          print("ESP32 → $data");

          _messageController.add(data);
        },
        onError: (error) {
          print("WebSocket Error: $error");

          _messageController.addError(error);
        },
        onDone: () {
          print("WebSocket connection closed");

          _channel = null;
          _subscription = null;
        },
      );

      // Register this phone/user
      registerUser();
    } catch (e) {
      print("WebSocket connection failed: $e");

      _channel = null;
    }
  }

  // ─────────────────────────────────────────────
  // REGISTER USER
  // ─────────────────────────────────────────────

  void registerUser() {
    if (_channel == null) {
      print("Cannot register. WebSocket not connected.");
      return;
    }

    if (_username == null || _username!.isEmpty) {
      print("Cannot register. Username is empty.");
      return;
    }

    final message = {"type": "register", "username": _username};

    final jsonMessage = jsonEncode(message);

    print("Registering user: $jsonMessage");

    _channel!.sink.add(jsonMessage);
  }

  // ─────────────────────────────────────────────
  // EVERYONE CHAT
  // ─────────────────────────────────────────────

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

    final jsonMessage = jsonEncode(message);

    print("Sending to everyone: $jsonMessage");

    // IMPORTANT:
    // Send ONLY ONCE.
    _channel!.sink.add(jsonMessage);
  }

  // ─────────────────────────────────────────────
  // PERSONAL CHAT
  // ─────────────────────────────────────────────

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
      "type": "message",
      "sender": sender,
      "receiver": receiver,
      "text": text,
      "time": DateTime.now().millisecondsSinceEpoch,
    };

    final jsonMessage = jsonEncode(message);

    print(
      "Sending personal message "
      "$sender → $receiver: $jsonMessage",
    );

    _channel!.sink.add(jsonMessage);
  }

  // ─────────────────────────────────────────────
  // STREAM
  // ─────────────────────────────────────────────

  Stream<dynamic> get stream {
    return _messageController.stream;
  }

  // ─────────────────────────────────────────────
  // DISCONNECT
  // ─────────────────────────────────────────────

  void disconnect() {
    print("Disconnecting from ESP32...");

    _subscription?.cancel();
    _subscription = null;

    _channel?.sink.close();
    _channel = null;

    _username = null;

    print("Disconnected");
  }

  // ─────────────────────────────────────────────
  // STATUS
  // ─────────────────────────────────────────────

  bool get isConnected {
    return _channel != null;
  }

  String? get username {
    return _username;
  }

  // ─────────────────────────────────────────────
  // CLEANUP
  // ─────────────────────────────────────────────

  void dispose() {
    disconnect();

    _messageController.close();
  }
}
