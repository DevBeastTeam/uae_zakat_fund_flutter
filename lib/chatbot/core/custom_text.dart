import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    this.color,
    this.height,
    this.shadows,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.decoration,
    this.wordSpacing,
    this.fontSize = 14,
    required this.text,
    this.letterSpacing,
    this.textDirection,
    this.canTrans = true,
    this.decorationThickness = 2,
    this.fontWeight = FontWeight.w400,
  });
  final String text;
  final Color? color;
  final bool canTrans;
  final int? maxLines;
  final double? height;
  final double fontSize;
  final double? wordSpacing;
  final TextAlign? textAlign;
  final double? letterSpacing;
  final FontWeight fontWeight;
  final List<Shadow>? shadows;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final double decorationThickness;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      textDirection: textDirection,
      style: TextStyle(
        color: color ?? Colors.black,
        height: height,
        shadows: shadows,
        fontSize: fontSize,
        decoration: decoration,
        fontWeight: fontWeight,
        decorationColor: color,
        wordSpacing: wordSpacing,
        letterSpacing: letterSpacing,
        decorationThickness: decorationThickness,
      ),
    );
  }
}
