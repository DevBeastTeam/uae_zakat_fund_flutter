import 'package:flutter/material.dart';

class ChatBotAiLoading extends StatelessWidget {
  final double? size;
  final double? strokeWidth;
  final Color? color;

  const ChatBotAiLoading({super.key, this.size, this.strokeWidth, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: size,
          width: size,
          child: CircularProgressIndicator(
            color: color ?? Colors.white,
            strokeWidth: strokeWidth ?? 2,
          ),
        ),
      ],
    );
  }
}
