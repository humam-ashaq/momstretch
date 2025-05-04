import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final otpController = TextEditingController();

  RxBool isLoading = false.obs;

  void sendResetEmail() {
    isLoading.value = true;
    // Simulasi pengiriman email
    Future.delayed(Duration(seconds: 2), () {
      isLoading.value = false;
      Get.toNamed('/forgot-otp');
    });
  }

  void verifyOtpAndContinue() {
    if (otpController.text == "1234") {
      Get.toNamed('/forgot-reset');
    } else {
      Get.snackbar('Error', 'Kode OTP salah');
    }
  }

  void setNewPassword() {
    if (newPasswordController.text == confirmPasswordController.text) {
      Get.snackbar('Success', 'Password berhasil diubah');
      Get.offNamed('/login');
    } else {
      Get.snackbar('Error', 'Password tidak cocok');
    }
  }
}