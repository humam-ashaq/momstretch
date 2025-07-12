import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../services/auth_service.dart';

class ProfileController extends GetxController {
  var nama = ''.obs;
  var email = ''.obs;
  var program = ''.obs;
  var usia = ''.obs;
  var fotoProfil = ''.obs;
  var isLoading = true.obs;
  final usiaC = TextEditingController();
  final fotoProfilC = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final token = AuthService.getToken();
    print('Token fetch: ${token}');
    isLoading.value = true;
    final result = await AuthService.getProfile();
    if (result['success']) {
      final data = result['data'];
      nama.value = data['nama'] ?? '';
      email.value = data['email'] ?? '';
      usia.value = data['usia']?.toString() ?? '';
      fotoProfil.value = data['foto_profil'] ?? '';
      final programFromDb = data['program'] ?? '';

      String displayProgram;
      switch (programFromDb.toLowerCase()) {
        case 'normal':
          displayProgram = 'Persalinan Normal';
          break;
        case 'caesar':
          displayProgram = 'Persalinan Operasi Caesar';
          break;
        default:
          displayProgram = 'Program Belum Dipilih';
      }

      program.value = displayProgram;

      // Update controllers dengan data yang ada.
      usiaC.text = usia.value;
      fotoProfilC.text = fotoProfil.value;
    }
    isLoading.value = false;
  }

  Future<void> updateProfile() async {
    isLoading.value = true;
    final result = await AuthService.updateProfile(
      usiaC.text,
      fotoProfilC.text,
    );
    isLoading.value = false;
    if (result['success']) {
      Get.snackbar('Sukses', result['message']);
      await fetchProfile(); // Refresh data profil
    } else {
      Get.snackbar('Error', result['message']);
    }
  }

  var selectedImage = Rxn<File>(); // null-safe observable

  Future<void> pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
      fotoProfilC.text = pickedFile.path; // Kalau backend masih pakai URL / path lokal
    }
  }

  void performLogout() {
    Get.defaultDialog(
      title: "Keluar",
      middleText: "Apakah kamu yakin ingin keluar?",
      textCancel: "Batal",
      textConfirm: "Keluar",
      confirmTextColor: Colors.white,
      onConfirm: () {
        AuthService.logout();
        Get.offAllNamed('/login');
      },
    ); // Atau route sesuai nama halaman login kamu
  }

  @override
  void onClose() {
    usiaC.dispose();
    fotoProfilC.dispose();
    super.onClose();
  }
}
