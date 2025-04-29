import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomSnackbar(String title, String message,
      {Color backgroundColor = Colors.black}) {
    Get.snackbar(
      '',
      '',
      titleText: Text(
        title,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
      animationDuration: const Duration(milliseconds: 500),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }