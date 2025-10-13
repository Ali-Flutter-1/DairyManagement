import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double? height;
  final Color backgroundColor;
  final TextStyle textStyle;
  final BorderRadiusGeometry? borderRadius;
  final Border? border;
  final Widget? image;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.width,
    required this.textStyle,
    required this.backgroundColor,
    this.height,
    this.borderRadius,
    this.border,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 56,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        border: border,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (image != null) ...[
              image!,
              const SizedBox(width: 10),
            ],
            Text(text, style: textStyle),
          ],
        ),
      ),
    );
  }
}
