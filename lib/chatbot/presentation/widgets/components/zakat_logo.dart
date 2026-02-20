import 'package:flutter/material.dart';
import 'package:zakat_fund/chatbot/presentation/widgets/components/rounded_container.dart';

class ZakatLogo extends StatelessWidget {
  final double size;
  final double radius;

  const ZakatLogo({super.key, this.size = 40, this.radius = 15});

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      height: size,
      width: size,
      radius: radius,
      backgroundColor: Colors.amber,
      child: const SizedBox(),
    );
  }
}
