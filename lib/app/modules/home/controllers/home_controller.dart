import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mom_stretch/app/data/app_colors.dart';

class HomeController extends GetxController {

  @override
  void onInit() {
    super.onInit();
  }
  
  final articles = [
    {
      'image': 'assets/images/berita.png',
      'title': 'Bunda, Ini yang Terjadi pada Dirimu\nSesudah Melahirkan',
    },
    {
      'image': 'assets/images/berita.png',
      'title': 'Bolehkah Ibu Tidur Siang Setelah\nMelahirkan?',
    },
    {
      'image': 'assets/images/berita.png',
      'title': 'Tips Mengatur Pola Makan Pasca\nPersalinan',
    },
  ];

  void onExploreStretching() {
    Get.toNamed('/stretching');
  }

  void onReadNowPressed() {
    Get.toNamed('/article');
  }

  void onViewAllPressed() {
    Get.toNamed('/article');
  }

  Widget buildArticleCard(String image, String title) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 24,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  shadows: [
                    Shadow(
                      blurRadius: 4.0,
                      color: Colors.black54,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: onReadNowPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.forthColor,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Baca Sekarang', style: TextStyle(
                  color: AppColors.primaryColor
                ),),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
