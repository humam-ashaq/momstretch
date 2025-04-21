import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';
import 'package:flutter_svg/svg.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SplashView'),
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xFF926F6D),
        child: Column(
          children: [
            SvgPicture.asset(
              'assets/images/logo.svg',
              width: 64,
              height: 64,
            ),
            SizedBox(height: 64,),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
