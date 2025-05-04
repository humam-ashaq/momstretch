import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mom_stretch/app/data/app_colors.dart';
import 'package:mom_stretch/app/modules/main/controllers/main_controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // nanti ambil dari database
                      'Welcome, Asihra',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    // Greeting + Notification Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Halo Mom!\nSiap kembali bugar dan\nbahagia setelah melahirkan?\nYuk Stretching bareng!',
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            // Explore Button
                            ElevatedButton(
                              onPressed: () {
                                final mainController =
                                    Get.find<MainController>();
                                mainController.navigateToStretching();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                'Explore Stretching',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Image.asset(
                          'assets/images/pilihprogram.png',
                          height: 100,
                        )
                      ],
                    ),

                    const SizedBox(height: 24),

                    ...controller.articles.map((article) => Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: controller.buildArticleCard(
                              article['image']!, article['title']!),
                        )),
                    const SizedBox(height: 8),
                    Center(
                      child: ElevatedButton(
                        onPressed: controller.onViewAllPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'View All',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 16,
            child: ElevatedButton(
              onPressed: () {
                final mainController = Get.find<MainController>();
                mainController.navigateToMoodCheck();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.forthColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.forthColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Health Test',
                          style: TextStyle(fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor),
                        ),
                        SizedBox(height: 4),
                        Text('Detect baby blues with EPDS',style: TextStyle(
                          color: AppColors.primaryColor),),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.primaryColor,),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
