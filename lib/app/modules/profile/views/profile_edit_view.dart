import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mom_stretch/app/data/app_colors.dart';
import '../controllers/profile_controller.dart';

class ProfileEditView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Edit Profil', style: TextStyle(
        color: AppColors.primaryColor
      ),), backgroundColor: Colors.white,),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: controller.usiaC,
                decoration: const InputDecoration(
                  labelText: 'Usia',
                  hintText: 'Masukkan usia',
                  fillColor: AppColors.primaryColor
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Text('Foto Profil', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Obx(() {
                final imageFile = controller.selectedImage.value;
                return Column(
                  children: [
                    GestureDetector(
                      onTap: controller.pickImageFromGallery,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: imageFile != null
                              ? DecorationImage(
                                  image: FileImage(imageFile),
                                  fit: BoxFit.cover)
                              : controller.fotoProfil.value.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(
                                          controller.fotoProfil.value),
                                      fit: BoxFit.cover)
                                  : null,
                          color: Colors.grey[300],
                        ),
                        child: imageFile == null &&
                                controller.fotoProfil.value.isEmpty
                            ? Icon(Icons.camera_alt,
                                size: 40, color: Colors.grey[700])
                            : null,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: controller.pickImageFromGallery,
                      child: Text('Pilih dari Galeri', style: TextStyle(
                        color: AppColors.primaryColor
                      ),),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor
                ),
                onPressed: () {
                  controller.updateProfile();
                },
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Update Profil', style: TextStyle(
                      color: Colors.white
                    ),),
              ),
            ],
          ),
        );
      }),
    );
  }
}
