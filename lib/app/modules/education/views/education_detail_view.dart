import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mom_stretch/app/data/app_colors.dart';
import '../controllers/education_controller.dart';

class EducationDetailView extends GetView<EducationController> {
  const EducationDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final data = controller.selectedEducation.value;

    if (data == null) {
      return const Scaffold(
        body: Center(child: Text('Tidak ada data edukasi')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.primaryColor,),
                onPressed: () => Get.back(),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  data['image'] ?? '',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                data['title'] ?? '',
                style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                data['subtitle'] ?? '',
                style: const TextStyle(fontSize: 16, color: AppColors.primaryColor),
              ),
              const SizedBox(height: 24),
              const Text(
                // Konten placeholder
                "Setelah melewati proses persalinan yang panjang dan menegangkan, tubuh Bunda pasti membutuhkan waktu istirahat yang cukup. "
                "Apalagi, sibuk merawat bayi baru lahir membuat Bunda cepat merasa lelah. Yuk, ketahui bagaimana cara menjaga kesehatan setelah melahirkan!",
                style: TextStyle(fontSize: 14, height: 1.6, color: AppColors.primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
