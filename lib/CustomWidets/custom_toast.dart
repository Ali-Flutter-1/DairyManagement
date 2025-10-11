import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';

void showCustomToast(BuildContext context, String message,
    {bool isError = false}) {
  DelightToastBar(
    builder: (context) {
      return ToastCard(
        shadowColor: isError ? Colors.red : Color(0xFF7CB342),
        title: Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        leading: Icon(
          isError ? Icons.error : Icons.check_circle,
          size: 28,
          color: isError ? Colors.red : Color(0xFF7CB342),
        ),
      );
    },
    position: DelightSnackbarPosition.top,
    autoDismiss: true,
  ).show(context);
}
