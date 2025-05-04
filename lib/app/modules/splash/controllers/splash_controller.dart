import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> fadeAnimation;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    fadeAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );

    animationController.forward();

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _checkLogin();
      }
    });
  }

  void _checkLogin() {
    final token = AuthService.box.read('token');
    print('token: ${token}');
    if (token != null && token.isNotEmpty) {
      Get.offAllNamed('/main'); // Kalau sudah login, ke halaman home
    } else {
      Get.offAllNamed('/login'); // Kalau belum login, ke halaman login
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
