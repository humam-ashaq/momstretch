import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/app_colors.dart';
import '../controllers/stretching_controller.dart';

class StretchingDetailView extends GetView<StretchingController> {
  const StretchingDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final stretching = controller.selectedStretching.value;

    if (stretching == null) {
      return const Scaffold(
        body: Center(child: Text("Data tidak tersedia")),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.forthColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        stretching.stretching,
                        style: const TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        
              // Subjudul
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${stretching.duration}, ${stretching.program}',
                    style: const TextStyle(
                        fontSize: 16, color: AppColors.primaryColor),
                  ),
                ),
              ),
        
              const SizedBox(height: 12),
        
              // Deskripsi program
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    stretching.stretchingDesc, 
                    style: const TextStyle(
                        fontSize: 14, color: AppColors.primaryColor),
                  ),
                ),
              ),
        
              const SizedBox(height: 24),
        
              // Label daftar gerakan
              Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'DAFTAR GERAKAN',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.primaryColor),
                  ),
                ),
              ),
        
              const SizedBox(height: 16),

              // List gerakan
              Obx(() {
                if (controller.isMovementsLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.movementList.isEmpty) {
                  return const Center(child: Text("Tidak ada gerakan untuk program ini."));
                }
                return ListView.builder(
                  // TAMBAHKAN properti ini
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  // ---
                  itemCount: controller.movementList.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    final item = controller.movementList[index];
                    return Card(
                      // ... sisa kode Card tidak berubah ...
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.white,
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Image.network(
                                  item.imageUrl ?? 'https://via.placeholder.com/48x48?text=N/A',
                                  width: 48,
                                  height: 48,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    item.movement,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(color: AppColors.secondaryColor),
                            TextButton(
                              onPressed: () {
                                controller.showMovementDetail(item);
                              },
                              child: const Row(
                                children: [
                                  Text(
                                    "Lihat Detail",
                                    style: TextStyle(color: AppColors.primaryColor),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.chevron_right,
                                    color: AppColors.primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
