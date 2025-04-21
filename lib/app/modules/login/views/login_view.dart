import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    final mainColor = Color(0xFF52463D);

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
                  Icon(Icons.arrow_back_ios, size: 24),
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
                'Masuk',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: mainColor,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Email',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: mainColor,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.emailController,
                decoration: InputDecoration(
                  hintText: 'Masukan alamat email anda',
                  filled: true,
                  fillColor: Color(0xFFF0EFF6),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Kata Sandi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: mainColor,
                ),
              ),
              const SizedBox(height: 8),
              Obx(() => TextField(
                    controller: controller.passwordController,
                    obscureText: controller.isPasswordHidden.value,
                    decoration: InputDecoration(
                      hintText: 'Masukan Kata Sandi',
                      filled: true,
                      fillColor: Color(0xFFF0EFF6),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      suffixIcon: IconButton(
                        icon: Icon(controller.isPasswordHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  )),
              const SizedBox(height: 8,),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Tambahkan navigasi lupa password kalau perlu
                      },
                      child: Text(
                        'Lupa Kata Sandi?',
                        style: TextStyle(
                            fontSize: 12,
                            color: mainColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(' - '),
                    TextButton(
                      onPressed: () {
                        Get.toNamed('/register');
                      },
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 12,
                            color: mainColor
                          ),
                          children: [
                            TextSpan(
                              text: 'Belum punya akun? '
                            ),
                            TextSpan(
                              text: 'Daftar',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/program');
                  },
                  // controller.login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'MASUK',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
