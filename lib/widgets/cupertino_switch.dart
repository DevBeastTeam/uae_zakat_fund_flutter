import 'package:flutter/cupertino.dart';

class CupertinoSwitchWidget extends StatelessWidget {
  final bool value;
  final void Function(bool)? onChanged;
  const CupertinoSwitchWidget({super.key, required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      value: value,
      onChanged: onChanged,
    );
  }
}
