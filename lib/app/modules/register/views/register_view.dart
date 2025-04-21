import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    final mainColor = const Color(0xFF52463D);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () => Get.back(),
                  ),
                  Text(
                    'MOMSTRETCH+',
                    style: TextStyle(
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.amber[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Text(
                'Daftar',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: mainColor,
                ),
              ),
              const SizedBox(height: 24),
              Text('Nama Pengguna', style: labelStyle(mainColor)),
              const SizedBox(height: 8),
              inputField(controller.nameController, 'Masukan nama anda'),
              const SizedBox(height: 16),
              Text('Email', style: labelStyle(mainColor)),
              const SizedBox(height: 8),
              inputField(controller.emailController, 'Masukan alamat email anda'),
              const SizedBox(height: 16),
              Text('Kata Sandi', style: labelStyle(mainColor)),
              const SizedBox(height: 8),
              Obx(() => passwordField(
                    controller.passwordController,
                    'Masukan kata sandi anda',
                    controller.isPasswordHidden,
                    controller.togglePasswordVisibility,
                  )),
              const SizedBox(height: 16),
              Text('Konfirmasi kata sandi', style: labelStyle(mainColor)),
              const SizedBox(height: 8),
              Obx(() => passwordField(
                    controller.confirmPasswordController,
                    'Masukan ulang kata sandi anda',
                    controller.isConfirmPasswordHidden,
                    controller.toggleConfirmPasswordVisibility,
                  )),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Get.toNamed('/login');
                  },
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 12,
                        color: mainColor
                      ),
                      children: [
                        TextSpan(
                          text: 'Sudah punya akun? '
                        ),
                        TextSpan(
                          text: 'Masuk',
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          )
                        )
                      ]
                    )),),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: controller.register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'DAFTAR',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
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
