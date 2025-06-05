import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/verify_email_controller.dart';
import '../../../../data/app_colors.dart';

class VerifyEmailView extends GetView<VerifyEmailController> {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context) {
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
              crossAxisAlignment: CrossAxisAlignment.center,
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
                          fontSize: 20,
                          color: AppColors.tertiaryColor),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Image.asset('assets/images/otp_email.png', height: 200),
                const SizedBox(height: 32),
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primaryColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Verifikasi Email',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text(
                          'Masukkan 6 digit kode OTP yang telah dikirim ke email kamu.',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[600])),
                      SizedBox(height: 24),
                      TextField(
                        controller: controller.otpC,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 6,
                        decoration: InputDecoration(
                          hintText: '------',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 24),
                      Obx(() => SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : controller.verifyOtp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                padding: EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: controller.isLoading.value
                                  ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      'Verifikasi',
                                      style: TextStyle(color: Colors.white),
                                    ),
                            ),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
