import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final String? prefixText;
  final TextEditingController? controller;
  final int? maxLength;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
     this.label,
    this.icon,
    this.prefixText,
    this.controller,
    this.maxLength,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(

      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: icon != null ? Icon(icon, color: Colors.grey[600]) : null,
        ),
        prefixText: prefixText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.green),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        isDense: true,
        counterText: '', // hides maxLength counter
      ),
      style: const TextStyle(fontSize: 18, fontFamily: 'Font',fontWeight: FontWeight.w600),
    );
  }
}
