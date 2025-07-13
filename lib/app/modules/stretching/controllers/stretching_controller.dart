import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:video_player/video_player.dart';
import '../../../services/auth_service.dart';
import '../../../services/stretching_service.dart';
import '../views/stretching_detail_sheet.dart';

class StretchingController extends GetxController {
  final StretchingService _stretchingService = StretchingService();
  Interpreter? interpreter;
  List<String> labels = [];
  CameraController? cameraController;
  List<CameraDescription> cameras = [];
  int selectedCameraIndex = 0;
  final poseDetector = PoseDetector(
    options: PoseDetectorOptions(mode: PoseDetectionMode.stream),
  );
  bool isDetecting = false;
  VideoPlayerController? videoPlayerController;
  final programController = TextEditingController();

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
    loadModel();
    fetchProfileAndStretching();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    interpreter?.close();
    videoPlayerController?.dispose();
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

  void goToStretchingCamera() async {
    // Pastikan movement sudah dipilih sebelum ke kamera
    if (selectedMovementDetail.value == null) {
      Get.snackbar('Perhatian', 'Pilih gerakan terlebih dahulu.');
      return;
    }
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

  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset('assets/models/model.tflite');
      final labelData = await rootBundle.loadString('assets/labels/label.txt');
      // Pastikan label bersih dari spasi atau baris kosong
      labels = labelData
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      debugPrint('✅ Model dan ${labels.length} Label berhasil dimuat');
    } catch (e) {
      debugPrint("❌ Error loading model: $e");
    }
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

  // Di dalam StretchingController.dart

  void processCameraImage(CameraImage image) async {
    debugPrint("📸 FRAME DITERIMA! Timestamp: ${DateTime.now()}");
    // Jangan proses jika interpreter belum siap, sedang memproses, atau belum ada gerakan yang dipilih
    // if (interpreter == null || isDetecting || selectedMovementId.value.isEmpty)
    //   return;
    // isDetecting = true;

    // try {
    //   // --- Langkah 1: Pre-processing Gambar (sama seperti sebelumnya) ---
    //   final WriteBuffer allBytes = WriteBuffer();
    //   for (final Plane plane in image.planes) {
    //     allBytes.putUint8List(plane.bytes);
    //   }
    //   final bytes = allBytes.done().buffer.asUint8List();

    //   final rotation = InputImageRotationValue.fromRawValue(
    //           cameraController!.description.sensorOrientation) ??
    //       InputImageRotation.rotation0deg;
    //   final format = InputImageFormatValue.fromRawValue(image.format.raw);
    //   if (format == null) {
    //     isDetecting = false;
    //     return;
    //   }

    //   final inputImage = InputImage.fromBytes(
    //     bytes: bytes,
    //     metadata: InputImageMetadata(
    //       size: Size(image.width.toDouble(), image.height.toDouble()),
    //       rotation: rotation,
    //       format: format,
    //       bytesPerRow: image.planes[0].bytesPerRow,
    //     ),
    //   );

    //   // --- Langkah 2: Deteksi Pose ---
    //   final poses = await poseDetector.processImage(inputImage);

    //   // DEBUG: Cek apakah pose terdeteksi
    //   if (poses.isEmpty) {
    //     debugPrint("👀 Tidak ada pose yang terdeteksi di frame ini.");
    //     isDetecting = false;
    //     return;
    //   }
    //   debugPrint("✅ Pose terdeteksi!");

    //   // --- Langkah 3: Ekstraksi Keypoints ---
    //   final List<double> keypoints = [];
    //   for (var lmType in PoseLandmarkType.values) {
    //     final lm = poses.first.landmarks[lmType];
    //     keypoints.addAll(lm != null ? [lm.x, lm.y, lm.z] : [0.0, 0.0, 0.0]);
    //   }
    //   if (keypoints.length != 99) {
    //     isDetecting = false;
    //     return;
    //   }

    //   // --- Langkah 4: Jalankan Model TFLite ---
    //   final input = [keypoints];
    //   final output = List.generate(1, (_) => List.filled(labels.length, 0.0));

    //   debugPrint("🚀 Menjalankan model TFLite...");
    //   interpreter!.run(input, output);
    //   debugPrint("✅ Model TFLite selesai dijalankan.");

    //   final List<double> predictions = output[0];

    //   // --- Langkah 5: Cari Skor untuk Label Target ---
    //   // DEBUG: Tampilkan label yang sedang dicari
    //   debugPrint("🎯 Mencari label target: '${selectedMovementId.value}'");

    //   final int targetIndex = labels.indexOf(selectedMovementId.value);

    //   // DEBUG: Cek apakah label ditemukan
    //   if (targetIndex == -1) {
    //     debugPrint(
    //         "❌ FATAL: Label '${selectedMovementId.value}' tidak ditemukan di dalam file label.txt!");
    //     debugPrint(
    //         "Pastikan teks di database dan di label.txt sama persis (termasuk spasi/huruf besar-kecil).");
    //     movementStatusText.value = 'Error: Label tidak cocok!';
    //     isDetecting = false;
    //     return;
    //   }
    //   debugPrint("✅ Label ditemukan di index: $targetIndex");

    //   // --- Langkah 6: Update UI Berdasarkan Skor ---
    //   final double accuracy = predictions[targetIndex];
    //   const double accuracyThreshold = 0.85;

    //   // DEBUG: Tampilkan skor akurasi
    //   debugPrint(
    //       "📊 Akurasi untuk '${selectedMovementId.value}': ${(accuracy * 100).toStringAsFixed(2)}%");

    //   if (accuracy >= accuracyThreshold) {
    //     movementStatusText.value = '✅ Gerakan Sudah Tepat';
    //   } else {
    //     movementStatusText.value = '❌ Gerakan Belum Sesuai';
    //   }
    // } catch (e) {
    //   debugPrint("❌ Terjadi error saat deteksi: $e");
    // } finally {
    //   isDetecting = false;
    // }
  }

  // Di dalam StretchingController.dart

  Future<void> initializeCamera() async {
    // Reset status untuk debug
    isCameraInitialized.value = false;
    debugPrint("--- [PROSES INISIALISASI KAMERA DIMULAI] ---");

    try {
      // [DARI KODE ANDA] Memaksa orientasi menjadi landscape
      debugPrint("1. Mengatur orientasi layar ke landscape...");
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);

      debugPrint("2. Mencari kamera depan...");
      final cameras = await availableCameras();
      final frontCam = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      debugPrint("3. Kamera depan ditemukan. Membuat CameraController...");

      cameraController = CameraController(
        frontCam,
        ResolutionPreset.medium,
        enableAudio: false,
        // [DARI KODE SAYA] Memaksa format gambar yang kompatibel
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await cameraController!.initialize();
      debugPrint("4. CameraController.initialize() SELESAI.");

      debugPrint("5. MENCOBA MEMULAI IMAGE STREAM...");
      await cameraController!.startImageStream(processCameraImage);
      debugPrint("6. ✅✅✅ startImageStream BERHASIL DIMULAI! Menunggu data...");

      isCameraInitialized.value = true;
      update();
      debugPrint(
          "7. isCameraInitialized di-set ke true. UI seharusnya menampilkan preview.");
    } catch (e, stacktrace) {
      debugPrint("❌❌❌ FATAL ERROR di initializeCamera: $e");
      debugPrint("Stacktrace: $stacktrace");
    }
  }

  // Dispose kamera saat keluar dari halaman
  void disposeCamera() {
    cameraController?.stopImageStream();
    cameraController?.dispose();
    cameraController = null;
    isCameraInitialized.value = false;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
