import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';

void showCustomToast(BuildContext context, String message,
    {bool isError = false}) {
  // Define background and icon colors based on error state
  final Color backgroundColor = isError ?  Colors.red :  Colors.green;
  final Color iconColor = Colors.white;


  DelightToastBar(
    builder: (context) {
      return ToastCard(
        shadowColor: Colors.transparent, // No shadow
        color: backgroundColor, // Background color
        title: Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: Colors.white, // Always white text
          ),
        ),
        leading: Icon(
          isError ? Icons.error : Icons.check_circle,
          size: 26,
          color: iconColor, // Always white icon
        ),
      );
    },
    position: DelightSnackbarPosition.bottom,
    autoDismiss: true,

  ).show(context);
}
