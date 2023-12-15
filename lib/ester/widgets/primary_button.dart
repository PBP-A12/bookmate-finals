import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
  }) : super(key: key);

  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(   
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? const Color(0xFFC44B6A),
        foregroundColor: textColor ?? Colors.white,
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}