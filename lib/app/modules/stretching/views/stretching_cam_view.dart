// lib/app/modules/stretching/views/stretching_cam_view.dart

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mom_stretch/app/data/app_colors.dart';
import '../controllers/stretching_controller.dart';

class StretchingCamView extends StatefulWidget {
  const StretchingCamView({super.key});

  @override
  State<StretchingCamView> createState() => _StretchingCamViewState();
}

class _StretchingCamViewState extends State<StretchingCamView> {
  final StretchingController controller = Get.find<StretchingController>();

  @override
  void initState() {
    super.initState();
    controller.initializeCamera();
  }

  @override
  void dispose() {
    controller.disposeCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Ganti background jadi hitam
      body: Obx(() {
        if (!controller.isCameraInitialized.value ||
            controller.cameraController == null ||
            !controller.cameraController!.value.isInitialized) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.white),
                SizedBox(height: 16),
                Text("Mempersiapkan kamera...",
                    style: TextStyle(color: Colors.white)),
              ],
            ),
          );
        }

        return Stack(
          fit: StackFit.expand,
          children: [
            // Widget untuk menampilkan preview kamera dengan benar
            _buildCameraPreview(),

            // Widget untuk UI di atas kamera
            _buildUIOverlay(),
          ],
        );
      }),
    );
  }

  Widget _buildCameraPreview() {
    return Transform.scale(
      scaleY: -1,
      child: Center(
        // Pastikan widget terpusat
        child: FittedBox(
          // INI KUNCI UTAMANYA: Tampilkan seluruh gambar, biarkan ada bar hitam jika perlu
          fit: BoxFit.contain,
          child: SizedBox(
            // Ukuran dibalik karena gambar akan diputar 90 derajat
            width: controller.cameraController!.value.previewSize!.width,
            height: controller.cameraController!.value.previewSize!.height,
            child: RotatedBox(
              quarterTurns: 3,
              child: CameraPreview(controller.cameraController!),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUIOverlay() {
    final movement = controller.selectedMovementDetail.value;
    return SafeArea(
      child: Stack(
        children: [
          // Header
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding:
                  const EdgeInsets.only(left: 8, right: 16, top: 8, bottom: 8),
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movement?.movement ?? 'Nama Gerakan',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Posisikan tubuh sesuai contoh',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Gambar Contoh
          Positioned(
            top: 16,
            right: 16, // Posisikan di kanan atas
            child: Container(
              width: 160,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  movement?.imageUrl ??
                      'https://via.placeholder.com/160x90?text=No+Image',
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) => progress == null
                      ? child
                      : const Center(child: CircularProgressIndicator()),
                  errorBuilder: (context, error, stack) =>
                      const Icon(Icons.error, color: Colors.red),
                ),
              ),
            ),
          ),

          // Label Prediksi
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Obx(() => Text(
                      controller.movementStatusText.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
