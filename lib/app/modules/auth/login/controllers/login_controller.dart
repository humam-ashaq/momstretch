import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../services/auth_service.dart';
import '../../../../data/widgets/custom_snackbar.dart';

class LoginController extends GetxController {
  late TextEditingController emailC;
  late TextEditingController passC;
  var isPasswordHidden = true.obs;
  var isLoading = false.obs;
  var program = ''.obs;

  @override
  void onInit() {
    super.onInit();
    emailC = TextEditingController();
    passC = TextEditingController();
  }

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
      final result2 = await AuthService.getProfile();
      if (result2['success']) {
        final data = result2['data'];
        program.value = data['program'] ?? '';

        if (program.isNotEmpty) {
          Get.offAllNamed('/main');
        } else {
          Get.offAllNamed('/program');
        }
      }
    } else {
      showCustomSnackbar('Error', result['message'],
          backgroundColor: Colors.red);
    }
  }

  Future<void> loginWithGoogle() async {
    isLoading.value = true;

    final result = await AuthService.signInWithGoogle();

    isLoading.value = false;

    if (result['success']) {
      showCustomSnackbar('Sukses', result['message'],
          backgroundColor: Colors.green);
      print('Token dari Google Login: ${AuthService.getToken()}');

      await Future.delayed(Duration(seconds: 1));
      final result2 = await AuthService.getProfile();
      if (result2['success']) {
        final data = result2['data'];
        program.value = data['program'] ?? '';

        if (program.isNotEmpty) {
          Get.offAllNamed('/main');
        } else {
          Get.offAllNamed('/program');
        }
      }
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
