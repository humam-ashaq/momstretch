import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../services/auth_service.dart';
import '../../../../data/widgets/custom_snackbar.dart';

class VerifyEmailController extends GetxController {
  final email = ''.obs; // Diset dari RegisterController
  final otpC = TextEditingController();
  RxBool isLoading = false.obs;

  Future<void> verifyOtp() async {
    if (otpC.text.isEmpty) {
      showCustomSnackbar('Error', 'Kode OTP wajib diisi',
          backgroundColor: Colors.red);
      return;
    }

    isLoading.value = true;
    final response = await AuthService.verifyOtp(email.value, otpC.text);
    isLoading.value = false;

    if (response['success']) {
      showCustomSnackbar('Sukses', response['message'],
          backgroundColor: Colors.green);
      await Future.delayed(Duration(seconds: 1));
      Get.offNamed('/login');
    } else {
      showCustomSnackbar('Error', response['message'],
          backgroundColor: Colors.red);
    }
  }

  @override
  void onClose() {
    otpC.dispose();
    super.onClose();
  }
}
