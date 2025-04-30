import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileEditView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil')),
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
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller.fotoProfilC,
                decoration: const InputDecoration(
                  labelText: 'URL Foto Profil',
                  hintText: 'Masukkan URL foto profil',
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
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
                    : const Text('Update Profil'),
              ),
            ],
          ),
        );
      }),
    );
  }
}
