import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';
import '../../../data/app_colors.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
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
                        fontFamily: 'HammersmithOne',
                        letterSpacing: 2,
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        color: AppColors.secondaryColor),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Text(
                'Daftar',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              Text('Nama',
                  style: controller.labelStyle(AppColors.primaryColor)),
              const SizedBox(height: 8),
              controller.inputField(controller.nameC, 'Masukan nama anda...'),
              const SizedBox(height: 16),
              Text('Email',
                  style: controller.labelStyle(AppColors.primaryColor)),
              const SizedBox(height: 8),
              controller.inputField(
                  controller.emailC, 'Masukan alamat email anda'),
              const SizedBox(height: 16),
              Text('Kata Sandi',
                  style: controller.labelStyle(AppColors.primaryColor)),
              const SizedBox(height: 8),
              Obx(() => controller.passwordField(
                    controller.passC,
                    'Masukan kata sandi anda',
                    controller.isPasswordHidden,
                    controller.togglePasswordVisibility,
                  )),
              const SizedBox(height: 16),
              Text('Konfirmasi kata sandi',
                  style: controller.labelStyle(AppColors.primaryColor)),
              const SizedBox(height: 8),
              Obx(() => controller.passwordField(
                    controller.confPassC,
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
                              fontSize: 12, color: AppColors.primaryColor),
                          children: [
                        TextSpan(text: 'Sudah punya akun? '),
                        TextSpan(
                            text: 'Masuk',
                            style: TextStyle(fontWeight: FontWeight.bold))
                      ])),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Obx(() => ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () {
                              controller.register(
                                controller.emailC.text,
                                controller.passC.text,
                                controller.confPassC.text,
                                controller.nameC.text,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        minimumSize: const Size(double.infinity, 50),
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
                              'DAFTAR',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
