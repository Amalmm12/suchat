import 'package:flutter/material.dart';
import '../models/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final bool isMe = message.isMe;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 310),
        margin: EdgeInsets.only(
          left: isMe ? 55 : 8,
          right: isMe ? 8 : 55,
          bottom: 10,
        ),
        padding: const EdgeInsets.fromLTRB(14, 10, 12, 8),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF1565C0) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMe ? 18 : 5),
            bottomRight: Radius.circular(isMe ? 5 : 18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            // Sender name
            if (!isMe)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  message.sender,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1565C0),
                  ),
                ),
              ),

            // Message text
            Text(
              message.text,
              style: TextStyle(
                fontSize: 16,
                height: 1.3,
                color: isMe ? Colors.white : const Color(0xFF222222),
              ),
            ),

            const SizedBox(height: 5),

            // Time
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(message.time),
                  style: TextStyle(
                    fontSize: 10,
                    color: isMe ? Colors.white70 : Colors.grey.shade600,
                  ),
                ),

                if (isMe) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.done_all_rounded,
                    size: 14,
                    color: Colors.white70,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}
