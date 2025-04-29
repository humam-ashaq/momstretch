import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';
import '../../../data/widgets/custom_snackbar.dart';

class LoginController extends GetxController {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  var isPasswordHidden = true.obs;
  var isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> login() async {
    final email = emailC.text.trim();
    final password = passC.text;

    if (email.isEmpty || password.isEmpty) {
      showCustomSnackbar('Error', 'Email dan password wajib diisi',
          backgroundColor: Colors.red);
      return;
    }

    isLoading.value = true;
    final result = await AuthService.login(email, password);
    isLoading.value = false;

    if (result['success']) {
      showCustomSnackbar('Sukses', result['message'],
          backgroundColor: Colors.green);
      await Future.delayed(Duration(seconds: 1));
      Get.offAllNamed('/program'); // arahkan ke home setelah login
    } else {
      showCustomSnackbar('Error', result['message'],
          backgroundColor: Colors.red);
    }
  }

  @override
  void onClose() {
    emailC.dispose();
    passC.dispose();
    super.onClose();
  }
}
