import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String? label;
  final IconData? icon;
  final String? prefixText;
  final TextEditingController? controller;
  final int? maxLength;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool enabled;
  final String? hintText;

  const CustomTextField({
    super.key,
    this.label,
    this.icon,
    this.prefixText,
    this.controller,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.enabled = true,
    this.hintText,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: widget.enabled ? Colors.white : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.07),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        enabled: widget.enabled,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        maxLength: widget.maxLength,
        obscureText: widget.isPassword && !_isVisible,
        style: const TextStyle(
          fontSize: 16,
          fontFamily: 'Font',
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
          prefixIcon: widget.icon != null
              ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Icon(widget.icon, color: Colors.green),
          )
              : null,
          prefixText: widget.prefixText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF56ab2f), width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF2b7a0b), width: 1.6),
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          isDense: true,
          counterText: '',
          suffixIcon: widget.isPassword
              ? IconButton(
            icon: Icon(
              _isVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isVisible = !_isVisible;
              });
            },
          )
              : null,
        ),
      ),
    );
  }
}
