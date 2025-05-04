import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/app_colors.dart';
import '../controllers/stretching_controller.dart';

class StretchingDetailView extends GetView<StretchingController> {
  const StretchingDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final stretching = controller.selectedStretching.value;
    final program = controller.selectedProgram.value ?? 'Program';
    final movements = controller.movementsForSelectedStretching;

    if (stretching == null) {
      return const Scaffold(
        body: Center(child: Text("Data tidak tersedia")),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.forthColor,
      body: SafeArea(
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
                      stretching['title'] ?? '',
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
                  '${stretching['duration']}, $program',
                  style: const TextStyle(fontSize: 16),
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
                  controller.getProgramDescription(program),
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
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
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // List gerakan
            Expanded(
              child: ListView.builder(
                itemCount: movements.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final item = movements[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                item['image']!,
                                width: 48,
                                height: 48,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  item['title']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: AppColors.primaryColor
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(color: AppColors.secondaryColor,),
                          TextButton(
                                onPressed: () {
                                  controller.showMovementDetail(item);
                                },
                                child: const Row(
                                  children: [
                                    Text(
                                      "Lihat Detail",
                                      style: TextStyle(
                                        color: AppColors.primaryColor
                                      ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
