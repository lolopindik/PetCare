import 'package:flutter/material.dart';

class SnackbarServices {
  static void showSnackbar(
    BuildContext context,
    String message, {
    Color? backgroundColor,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          width: (screenWidth > 600) ? MediaQuery.of(context).size.width * 0.5 :  MediaQuery.of(context).size.width * 0.8,
          content: Text(message, style: const TextStyle(color: Colors.white)),
          backgroundColor: backgroundColor ?? Colors.blueGrey,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else {
      debugPrint('Widget is no longer mounted. Snackbar skipped.');
    }
  }

  static void showSuccessSnackbar(BuildContext context, String message) {
    showSnackbar(context, message, backgroundColor: Colors.green);
  }

  static void showErrorSnackbar(BuildContext context, String errorMessage) {
    showSnackbar(context, errorMessage, backgroundColor: Colors.red);
  }

  static void showWarningSnackbar(BuildContext context, String message) {
    showSnackbar(context, message, backgroundColor: Colors.amber);
  }
}