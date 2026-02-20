import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? radius;
  final double? borderWidth;
  final double? height;
  final double? width;
  final FontWeight? fontWeight;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? shadowColor;
  final double? blurRadius;
  final double? spreadRadius;
  final bool hasBorder;
  final bool hasShadow;
  final Gradient? gradient;
  final BoxShape? shape;
  final Offset? offset;

  const RoundedContainer({
    super.key,
    required this.child,
    this.onPressed,
    this.padding,
    this.margin,
    this.fontWeight,
    this.borderWidth,
    this.radius,
    this.backgroundColor,
    this.borderColor,
    this.shadowColor,
    this.height,
    this.width,
    this.gradient,
    this.blurRadius,
    this.spreadRadius,
    this.shape,
    this.offset,
    this.hasBorder = false,
    this.hasShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        padding: padding ?? const EdgeInsets.all(8),
        margin: margin,
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 8),
          border: hasBorder
              ? Border.all(
                  width: borderWidth ?? 1,
                  color: borderColor ?? Colors.transparent,
                )
              : null,
        ),
        decoration: BoxDecoration(
          shape: shape ?? BoxShape.rectangle,
          color: backgroundColor,
          borderRadius: shape == BoxShape.circle
              ? null
              : BorderRadius.circular(radius ?? 8),
          gradient: gradient,
          boxShadow: hasShadow
              ? [
                  BoxShadow(
                    spreadRadius: spreadRadius ?? 0.5,
                    offset: offset ?? const Offset(2, 2),
                    blurRadius: blurRadius ?? 10,
                    color: shadowColor ?? Colors.grey.shade300,
                  ),
                ]
              : null,
        ),
        child: child,
      ),
    );
  }
}
