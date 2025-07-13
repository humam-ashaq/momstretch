import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mom_stretch/app/data/app_colors.dart';
import '../controllers/profile_controller.dart';

class ProfileEditView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: const Offset(0, 1),
                blurRadius: 1,
                spreadRadius: 1,
              )
            ]),
            child: AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.fromLTRB(12, 30, 12, 24),
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
                    Text(
                      'MOMSTRETCH+',
                      style: TextStyle(
                        letterSpacing: 2,
                        fontFamily: 'HammersmithOne',
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        color: Color.fromARGB(1000, 235, 203, 143),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.history,
                        color: Colors.transparent
                      ),
                      onPressed: () {
                      },
                    )
                  ],
                ),
              ),
            ),
          )),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Edit Profil',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller.namaC,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  hintText: 'Masukkan nama lengkap',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 24),
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedProgram.value,
                  decoration: const InputDecoration(
                    labelText: 'Program Persalinan',
                    border: OutlineInputBorder(),
                  ),
                  items: controller.programOptions
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      controller.selectedProgram.value = newValue;
                    }
                  },
                ),
              ),
              const SizedBox(height: 32),
              // Tombol Update
              Obx(
                () => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: controller.isLoading.value
                      ? null // Nonaktifkan tombol saat loading
                      : () => controller.updateProfile(),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Simpan Perubahan',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
