import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mom_stretch/app/modules/home/controllers/home_controller.dart';
import 'package:mom_stretch/app/modules/stretching/controllers/stretching_controller.dart';
import '../../../services/auth_service.dart';

class ProfileController extends GetxController {
  var nama = ''.obs;
  var email = ''.obs;
  var program = ''.obs;
  var usia = ''.obs;
  var fotoProfil = ''.obs;
  var isLoading = true.obs;
  final namaC = TextEditingController();
  var selectedProgram = 'Pilih Program'.obs;

  // List opsi untuk dropdown
  final List<String> programOptions = [
    'Pilih Program',
    'Persalinan Normal',
    'Persalinan Operasi Caesar'
  ];

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final result = await AuthService.getProfile();
      if (result['success']) {
        final data = result['data'];
        email.value = data['email'] ?? '';
        nama.value = data['nama'] ?? '';
        namaC.text = data['nama'] ?? '';

        // Konversi nilai 'program' dari DB ke teks yang ditampilkan di UI
        final programFromDb = data['program'] ?? '';
        switch (programFromDb.toLowerCase()) {
          case 'normal':
            selectedProgram.value = 'Persalinan Normal';
            break;
          case 'caesar':
            selectedProgram.value = 'Persalinan Operasi Caesar';
            break;
          default:
            selectedProgram.value = 'Pilih Program';
        }
      } else {
        Get.snackbar('Error', result['message'] ?? 'Gagal memuat profil.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    // Validasi input
    if (namaC.text.isEmpty) {
      Get.snackbar('Gagal', 'Nama tidak boleh kosong.');
      return;
    }
    if (selectedProgram.value == 'Pilih Program') {
      Get.snackbar('Gagal', 'Silakan pilih program persalinan.');
      return;
    }

    try {
      isLoading.value = true;
      final result = await AuthService.updateProfile(
        namaC.text,
        selectedProgram.value,
      );

      if (result['success']) {
        Get.back(); // Kembali ke halaman profil
        Get.snackbar('Sukses', result['message'] ?? 'Profil berhasil diperbarui.');
        // Refresh data di halaman sebelumnya jika perlu (misal, dengan Get.find)
        Get.find<ProfileController>().fetchProfile();
        Get.find<HomeController>().fetchProfile();
        Get.find<StretchingController>().fetchProfileAndStretching();
      } else {
        Get.snackbar('Error', result['message'] ?? 'Gagal memperbarui profil.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: ${e.toString()}');
    } finally {
      isLoading.value = false;
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
    super.onClose();
  }
}
