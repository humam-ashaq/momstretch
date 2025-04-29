import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';

class RegisterController extends GetxController {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final confPassC = TextEditingController();
  final nameC = TextEditingController();
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  Future<void> register(String email, String password, String confirmPassword, String nama) async {
    if (password != confirmPassword) {
      Get.snackbar('Error', 'Kata sandi dan konfirmasi tidak cocok');
      return;
    }

    isLoading.value = true;
    final result = await AuthService.register(email, password, nama);
    isLoading.value = false;

    if (result['success']) {
      Get.snackbar('Sukses', 'Registrasi berhasil, silakan login');
      await Future.delayed(Duration(milliseconds: 700)); // Tambahkan delay sedikit
      Get.offNamed('/login'); // balik ke login page
    } else {
      Get.snackbar('Error', result['message']);
    }
  }


  Widget inputField(TextEditingController ctrl, String hint) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF0EFF6),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget passwordField(TextEditingController ctrl, String hint,
      RxBool isHidden, VoidCallback toggle) {
    return TextField(
      controller: ctrl,
      obscureText: isHidden.value,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF0EFF6),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        suffixIcon: IconButton(
          icon: Icon(isHidden.value ? Icons.visibility_off : Icons.visibility),
          onPressed: toggle,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  TextStyle labelStyle(Color color) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }
}
