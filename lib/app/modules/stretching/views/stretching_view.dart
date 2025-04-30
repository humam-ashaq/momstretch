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
              Text(
                //nanti ambil dari database
                'Stretching Pasca Melahirkan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedProgram.value,
                    decoration: InputDecoration(
                      hintText: "Pilih Program Stretching",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    items: controller.programList.map((program) {
                      return DropdownMenuItem(
                        value: program,
                        child: Text(program),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.selectedProgram.value = value;
                    },
                  )),
              const SizedBox(
                height: 24,
              ),
              // List of workouts
              Expanded(
                child: Obx(() => ListView.builder(
                      itemCount: controller.stretchingList.length,
                      itemBuilder: (context, index) {
                        final item = controller.stretchingList[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              children: [
                                // Gambar
                                Image.asset(
                                  item['image']!,
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                                // Overlay gradasi semi transparan (opsional, untuk kontras)
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
                                // Konten di atas gambar
                                Positioned.fill(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['title']!,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                // Aksi Lihat Detail
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppColors.forthColor,
                                                foregroundColor: AppColors.primaryColor,
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
                                            const SizedBox(width: 12),
                                            ElevatedButton(
                                              onPressed: () {
                                                // Aksi Mulai Gerakan
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.brown,
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 8),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child:
                                                  const Text("Mulai Gerakan"),
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
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
