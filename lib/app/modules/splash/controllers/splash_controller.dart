import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  final box = GetStorage();

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
    String? token = box.read('token');

    if (token != null && token.isNotEmpty) {
      Get.offAllNamed('/home'); // Kalau sudah login, ke halaman pemilihan program
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
