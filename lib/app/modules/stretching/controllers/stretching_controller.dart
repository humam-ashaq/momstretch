import 'dart:async';
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../services/auth_service.dart';
import '../../../services/stretching_service.dart';
import '../views/stretching_detail_sheet.dart';
import 'package:audioplayers/audioplayers.dart';

class StretchingController extends GetxController {
  final StretchingService _stretchingService = StretchingService();
  bool _isLoopActive = false;
  List<String> labels = [];
  CameraController? cameraController;
  List<CameraDescription> cameras = [];
  int selectedCameraIndex = 0;
  bool isDetecting = false;
  VideoPlayerController? videoPlayerController;
  final programController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();

  var isStretchingLoading = true.obs;
  var isMovementsLoading = true.obs;
  var isVideoInitialized = false.obs;
  var isCameraInitialized = false.obs;

  final userProgram = ''.obs;
  final stretchingList = <Stretching>[].obs;
  final movementList = <Movement>[].obs;

  final selectedStretching = Rxn<Stretching>();
  final selectedMovementDetail = Rxn<MovementDetail>();
  final selectedMovementId = ''.obs;

  var movementStatusText = 'Arahkan kamera ke tubuh Anda'.obs;

  final Map<String, int> predictionCounter = {};
  static const int correctThreshold =
      5; // Jumlah deteksi berturut-turut untuk dianggap "benar"
  final RxString predictedLabel = ''.obs; // Untuk tampilan UI

  @override
  void onInit() {
    super.onInit();
    fetchProfileAndStretching();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    stopRealtimeBackendDetection();
    videoPlayerController?.dispose();
    _audioPlayer.dispose();
    programController.dispose();
    super.onClose();
  }

  Future<void> fetchProfileAndStretching() async {
    try {
      final result = await AuthService.getProfile();
      if (result['success']) {
        final data = result['data'];
        final programFromDb = data['program']?.toLowerCase() ?? 'normal';
        userProgram.value = programFromDb; // Simpan program (misal: 'normal')

        String displayProgram;
        switch (programFromDb) {
          case 'normal':
            displayProgram = 'Persalinan Normal';
            break;
          case 'caesar':
            displayProgram = 'Persalinan Operasi Caesar';
            break;
          default:
            displayProgram = 'Program Belum Dipilih';
        }
        programController.text = displayProgram;

        // Setelah tahu program user, fetch list stretching
        fetchStretchingList();
      } else {
        programController.text = 'Gagal memuat program';
        isStretchingLoading.value = false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat profil: $e');
      isStretchingLoading.value = false;
    }
  }

  Future<void> fetchStretchingList() async {
    try {
      isStretchingLoading.value = true;
      final result =
          await _stretchingService.getStretchingList(userProgram.value);
      stretchingList.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat daftar stretching: $e');
    } finally {
      isStretchingLoading.value = false;
    }
  }

  Future<void> fetchMovementList(String stretchingType) async {
    try {
      isMovementsLoading.value = true;
      movementList.clear(); // Kosongkan list sebelum fetch baru
      final result = await _stretchingService.getMovementList(stretchingType);
      movementList.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat daftar gerakan: $e');
    } finally {
      isMovementsLoading.value = false;
    }
  }

  void goToStretchingDetail(Stretching stretching) {
    selectedStretching.value = stretching;
    fetchMovementList(
        stretching.stretching); // Fetch gerakan untuk stretching yg dipilih
    Get.toNamed('/stretching-detail');
  }

  void showMovementDetail(Movement movement) async {
    try {
      // Ambil detail lengkap termasuk videoId dan deskripsi
      final detail = await _stretchingService.getMovementDetail(movement.id);
      selectedMovementDetail.value = detail;
      selectedMovementId.value =
          detail.movementId; // set target untuk deteksi pose

      initializeVideoPlayer(); // Inisialisasi video setelah dapat detail

      Get.bottomSheet(
        const StretchingDetailSheet(),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
      ).whenComplete(() {
        disposeVideoPlayer();
      });
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat detail gerakan: $e');
    }
  }

  void goToStretchingCamera() {
    if (selectedMovementDetail.value == null) {
      Get.snackbar('Perhatian', 'Pilih gerakan terlebih dahulu.');
      return;
    }
    selectedMovementId.value = selectedMovementDetail.value!.movementId;
    Get.toNamed('/stretching-cam');
  }

  Future<void> initializeVideoPlayer() async {
    final videoId = selectedMovementDetail.value?.videoId;
    if (videoId == null || videoId.isEmpty) {
      isVideoInitialized.value = false;
      return;
    }

    final videoUrl =
        Uri.parse('https://drive.google.com/uc?export=download&id=$videoId');
    videoPlayerController = VideoPlayerController.networkUrl(videoUrl);

    try {
      await videoPlayerController!.initialize();
      isVideoInitialized.value = true;
    } catch (e) {
      print("Error initializing video: $e");
      isVideoInitialized.value = false;
    }
  }

  void disposeVideoPlayer() {
    videoPlayerController?.dispose();
    videoPlayerController = null;
    isVideoInitialized.value = false;
  }

  Future<void> startCamera() async {
    cameras = await availableCameras();
    await initializeCamera();
  }

  Future<void> stopCamera() async {
    await cameraController?.stopImageStream();
    await cameraController?.dispose();
    cameraController = null;
    isCameraInitialized.value = false;
    predictedLabel.value = 'unknown';
  }

  Future<void> switchCamera() async {
    if (cameras.isEmpty) {
      cameras = await availableCameras();
    }
    await stopCamera();
    await initializeCamera();
  }

  void startRealtimeBackendDetection() {
    debugPrint("🚀 Memulai loop deteksi cerdas...");
    if (_isLoopActive) return; // Mencegah loop ganda
    _isLoopActive = true;
    _runDetectionLoop(); // Panggil loop untuk pertama kali
  }

  void stopRealtimeBackendDetection() {
    debugPrint("🛑 Menghentikan loop deteksi.");
    _isLoopActive = false;
  }

  Future<void> _runDetectionLoop() async {
    // Jika loop dihentikan di tengah jalan, jangan lanjutkan
    if (!_isLoopActive) return;

    // Jalankan satu siklus deteksi
    await checkPoseWithBackend();

    // Tentukan durasi delay berikutnya berdasarkan hasil deteksi
    Duration nextDelay;
    if (movementStatusText.value == '✅ Gerakan Sudah Tepat') {
      nextDelay = const Duration(seconds: 15);
      debugPrint(
          "Status Benar. Menunggu 15 detik untuk pengecekan berikutnya...");
    } else {
      nextDelay = const Duration(seconds: 2);
      debugPrint(
          "Status Belum Sesuai. Menunggu 2 detik untuk pengecekan berikutnya...");
    }

    // Jadwalkan eksekusi berikutnya setelah delay selesai
    Future.delayed(nextDelay, _runDetectionLoop);
  }

  Future<void> checkPoseWithBackend() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }

    try {
      movementStatusText.value = 'Menganalisis...';

      final XFile imageFile = await cameraController!.takePicture();
      final imageBytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(imageBytes);

      // Panggil service untuk melakukan API call
      final result = await _stretchingService.detectPose(
        base64Image: base64Image,
        targetLabel: selectedMovementId.value,
      );

      // 1. Simpan status baru dari hasil API
      final newStatus = result['status'] ?? 'Gagal memproses';

      // 2. Cek apakah statusnya berubah dari sebelumnya (untuk mencegah suara berulang)
      if (movementStatusText.value != newStatus) {
        // 3. Update teks di layar
        movementStatusText.value = newStatus;

        // 4. Mainkan suara berdasarkan status yang baru
        if (newStatus == '✅ Gerakan Sudah Tepat') {
          _playCorrectSound();
        } else if (newStatus == '❌ Gerakan Belum Sesuai') {
          _playIncorrectSound();
        }
      }
    } catch (e) {
      movementStatusText.value = 'Error: Cek koneksi';
      debugPrint("Error saat checkPoseWithBackend: $e");
    }
  }

  void _playCorrectSound() {
    _audioPlayer.play(AssetSource('audio/correct.mp3'));
  }

  void _playIncorrectSound() {
    _audioPlayer.play(AssetSource('audio/incorrect.mp3'));
  }

  Future<void> initializeCamera() async {
    isCameraInitialized.value = false;
    try {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      final cameras = await availableCameras();
      final frontCam = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      cameraController = CameraController(
        frontCam,
        ResolutionPreset.medium, // Resolusi medium sudah cukup untuk dikirim
        enableAudio: false,
      );
      await cameraController!.initialize();
      isCameraInitialized.value = true;
    } catch (e) {
      debugPrint("❌ FATAL ERROR di initializeCamera: $e");
    }
  }

  // Dispose kamera saat keluar dari halaman
  void disposeCamera() {
    cameraController?.dispose();
    isCameraInitialized.value = false;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
