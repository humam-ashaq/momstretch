import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/app_colors.dart';
import '../controllers/stretching_controller.dart';

class StretchingDetailSheet extends GetView<StretchingController> {
  const StretchingDetailSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final item = controller.selectedMovement.value;

    if (item == null) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: Text(
            "Data gerakan tidak tersedia",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.tertiaryColor, // Warna pink pastel
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              item['title'] ?? '',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              item['description'] ?? 'Tidak ada deskripsi.',
              style: const TextStyle(color: AppColors.primaryColor, fontSize: 14, height: 1.6),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: aksi mulai gerakan
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text("Mulai Gerakan"),
            ),
          ),
        ],
      ),
    );
  }
}
