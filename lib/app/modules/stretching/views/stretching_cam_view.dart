import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mom_stretch/app/data/app_colors.dart';
import '../controllers/stretching_controller.dart';

class StretchingCamView extends GetView<StretchingController> {
  const StretchingCamView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil detail gerakan dari controller
    final movement = controller.selectedMovementDetail.value;

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Obx(() { // Gunakan Obx untuk memantau status inisialisasi kamera
          if (!controller.isCameraInitialized.value ||
              controller.cameraController == null ||
              !controller.cameraController!.value.isInitialized) {
            // Tampilkan loading jika kamera belum siap
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 16),
                  Text("Mempersiapkan kamera...", style: TextStyle(color: Colors.white)),
                ],
              ),
            );
          }

          // Jika kamera sudah siap, tampilkan preview dan UI
          return Stack(
            children: [
              // --- PERBAIKAN UTAMA DI SINI ---
              // Kamera preview dikembalikan ke logika awal Anda yang sudah benar
              // untuk menghindari stretch/zoom.
              Positioned.fill(
                child: ClipRect(
                  child: OverflowBox(
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        // KEMBALIKAN KE LOGIKA AWAL ANDA (width -> width, height -> height)
                        width: controller.cameraController!.value.previewSize!.width,
                        height: controller.cameraController!.value.previewSize!.height,
                        child: CameraPreview(controller.cameraController!),
                      ),
                    ),
                  ),
                ),
              ),
              // --- AKHIR PERBAIKAN UTAMA ---

              // UI Overlay (Header, contoh gambar, dll)
              Positioned(
                top: 16,
                left: 0,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header (Tombol kembali dan info gerakan)
                    Container(
                      margin: const EdgeInsets.only(left: 16),
                      padding: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () {
                              controller.disposeCamera();
                              Get.back();
                            },
                          ),
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
                    const SizedBox(height: 12),

                    // Gambar contoh gerakan
                    Container(
                      margin: const EdgeInsets.only(left: 16),
                      width: 200,
                      height: 112,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.primaryColor, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          movement?.imageUrl ?? 'https://via.placeholder.com/200x112?text=No+Image',
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            return progress == null ? child : const Center(child: CircularProgressIndicator());
                          },
                          errorBuilder: (context, error, stack) {
                            return const Icon(Icons.error, color: Colors.red);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Label prediksi di bawah
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Obx(() => Text(
                      controller.predictedLabel.value.isEmpty
                          ? "Mendeteksi Gerakan..."
                          : controller.predictedLabel.value,
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
          );
        }),
      ),
    );
  }
}