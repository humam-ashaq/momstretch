import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mom_stretch/app/data/app_colors.dart';
import '../controllers/stretching_controller.dart';

class StretchingHistoryView extends GetView<StretchingController> {
  const StretchingHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Mengadopsi AppBar dari LoginLogsView
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 2),
              blurRadius: 4,
              spreadRadius: 1,
            )
          ]),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0, // Elevation diatur oleh Container
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.primaryColor,
                    ),
                    onPressed: () => Get.back(),
                  ),
                  // Ganti judul halaman di sini
                  const Text(
                    'MOMSTRETCH+',
                    style: TextStyle(
                      letterSpacing: 1.5,
                      fontFamily: 'HammersmithOne', // Pastikan font ini ada di proyek Anda
                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                      color: Color.fromARGB(255, 235, 203, 143), // Warna dari contoh
                    ),
                  ),
                  // Icon kosong untuk menyeimbangkan layout
                  IconButton(
                    icon: const Icon(Icons.help_outline, color: Colors.white),
                    onPressed: null,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.historyList.isEmpty) {
          // Ganti teks untuk empty state
          return const Center(
            child: Text(
              'Belum ada riwayat latihan',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        // Mengadopsi ListView.builder
        return ListView.builder(
          itemCount: controller.historyList.length,
          itemBuilder: (context, index) {
            final item = controller.historyList[index];
            // Menggunakan ListTile yang disesuaikan untuk data history
            return ListTile(
              leading: Icon(Icons.history, color: AppColors.primaryColor),
              title: Text(
                item.movementName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(item.timestamp),
            );
          },
        );
      }),
    );
  }
}