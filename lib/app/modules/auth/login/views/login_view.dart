import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../../../data/app_colors.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    final mainColor = AppColors.primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              top: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
                      onPressed: () => Get.back(),
                    ),
                    Text(
                      'MOMSTRETCH+',
                      style: TextStyle(
                          fontFamily: 'HammersmithOne',
                          letterSpacing: 2,
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                          color: AppColors.tertiaryColor),
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
                  controller: controller.emailC,
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
                      controller: controller.passC,
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
                const SizedBox(
                  height: 8,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // TextButton(
                      //   onPressed: () {
                      //     Get.toNamed('/forgot-password');
                      //   },
                      //   child: Text(
                      //     'Lupa Kata Sandi?',
                      //     style: TextStyle(
                      //         fontSize: 12,
                      //         color: mainColor,
                      //         fontWeight: FontWeight.bold),
                      //   ),
                      // ),
                      // Text(' - '),
                      TextButton(
                        onPressed: () {
                          Get.toNamed('/register');
                        },
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: 12, color: mainColor),
                            children: [
                              TextSpan(text: 'Belum punya akun? '),
                              TextSpan(
                                text: 'Daftar',
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                  child: Obx(() => ElevatedButton(
                        onPressed:
                            controller.isLoading.value ? null : controller.login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'MASUK',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      )),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey[400],
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        'atau',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey[400],
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                    height: 10),
                Center(
                  child: Obx(() => OutlinedButton.icon(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.loginWithGoogle,
                        icon: Image.asset(
                          'assets/icon/google_icon.png', // Pastikan Anda memiliki logo Google di folder assets
                          height: 24.0, // Sesuaikan ukuran logo
                        ),
                        label: Text(
                          'Masuk dengan Google',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ), // Warna teks hitam
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: AppColors.primaryColor), // Border hitam
                          backgroundColor: Colors.white, // Latar belakang putih
                          minimumSize:
                              Size(double.infinity, 50), // Ukuran minimum
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(30), // Sudut melengkung
                          ),
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
