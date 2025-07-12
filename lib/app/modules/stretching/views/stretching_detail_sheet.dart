import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/app_colors.dart';
import '../controllers/stretching_controller.dart';
import 'package:video_player/video_player.dart';

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

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
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
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24,),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Obx(() { // 4. GUNAKAN Obx
                if (controller.isVideoInitialized.value && controller.videoPlayerController != null) {
                  return AspectRatio(
                    aspectRatio: controller.videoPlayerController!.value.aspectRatio,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        VideoPlayer(controller.videoPlayerController!),
                        // Tambahkan Tombol Play/Pause
                        GestureDetector(
                          onTap: () {
                            if (controller.videoPlayerController!.value.isPlaying) {
                              controller.videoPlayerController!.pause();
                            } else {
                              controller.videoPlayerController!.play();
                            }
                            // Update UI tombol
                            controller.isVideoInitialized.refresh();
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.black.withOpacity(0.5),
                            child: Icon(
                              controller.videoPlayerController!.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  // 5. TAMPILKAN LOADING
                  return const AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  );
                }
              }),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                item['description'] ?? 'Tidak ada deskripsi.',
                style: const TextStyle(
                    color: AppColors.primaryColor, fontSize: 14, height: 1.6),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back(); // Tutup bottom sheet terlebih dahulu
                  Future.delayed(const Duration(milliseconds: 300), () {
                    controller.goToStretchingCamera(); // Pindah ke kamera
                  });
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
      ),
    );
  }
}
