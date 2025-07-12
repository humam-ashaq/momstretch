import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mom_stretch/app/data/app_colors.dart';
import '../controllers/stretching_controller.dart';

class StretchingView extends GetView<StretchingController> {
  const StretchingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Stretching Pasca Melahirkan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: controller
                    .programController, // Gunakan controller dari GetX
                readOnly: true, // Kunci utama: membuat field tidak bisa diedit
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  // Tambahkan ikon untuk memperjelas bahwa ini adalah info
                  prefixIcon: const Icon(
                    Icons.check_circle_outline,
                    color: AppColors.primaryColor,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: AppColors.primaryColor, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    // focusedBorder tetap ada untuk konsistensi
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: AppColors.primaryColor, width: 1.5),
                  ),
                ),
                style: const TextStyle(
                    color: AppColors.primaryColor, fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 24),

              // List Stretching
              Expanded(
                child: Obx(() {
                  // TAMBAHKAN: Cek loading state
                  if (controller.isStretchingLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.stretchingList.isEmpty) {
                    return const Center(
                        child: Text(
                            "Tidak ada program stretching yang tersedia."));
                  }
                  // ---
                  return ListView.builder(
                    itemCount: controller.stretchingList.length,
                    itemBuilder: (context, index) {
                      final item = controller.stretchingList[
                          index]; // item sekarang bertipe 'Stretching'
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            children: [
                              // Gambar Stretching
                              // GANTI Image.asset menjadi Image.network
                              Image.network(
                                item.imageUrl ??
                                    'https://via.placeholder.com/400x200?text=No+Image', // URL fallback
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) {
                                  return progress == null
                                      ? child
                                      : const Center(
                                          child: CircularProgressIndicator());
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error, size: 50);
                                },
                              ),

                              // Overlay gradasi hitam-transparan untuk kontras teks
                              Container(
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.6),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),

                              // Konten teks
                              Positioned.fill(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.stretching, // GANTI: item['title']! menjadi item.stretching
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              controller
                                                  .goToStretchingDetail(item);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.forthColor,
                                              foregroundColor:
                                                  AppColors.primaryColor,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: const Text("Lihat Detail"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
