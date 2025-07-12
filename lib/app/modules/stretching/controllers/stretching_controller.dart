import 'dart:math';
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
  final selectedMovementTarget = ''.obs;

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
      final result = await _stretchingService.getStretchingList(userProgram.value);
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
    fetchMovementList(stretching.stretching); // Fetch gerakan untuk stretching yg dipilih
    Get.toNamed('/stretching-detail');
  }

  void showMovementDetail(Movement movement) async {
    try {
      // Ambil detail lengkap termasuk videoId dan deskripsi
      final detail = await _stretchingService.getMovementDetail(movement.id);
      selectedMovementDetail.value = detail;
      selectedMovementTarget.value = detail.movement; // set target untuk deteksi pose
      
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
    await initializeCamera();
    Get.toNamed('/stretching-cam');
  }

  Future<void> initializeVideoPlayer() async {
    final videoId = selectedMovementDetail.value?.videoId;
    if (videoId == null || videoId.isEmpty) {
      isVideoInitialized.value = false;
      return;
    }

    final videoUrl = Uri.parse('https://drive.google.com/uc?export=download&id=$videoId');
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
      labels = labelData.split('\n').where((e) => e.trim().isNotEmpty).toList();

      debugPrint('✅ Model loaded');
      debugPrint('Labels: ${labels.length}');
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

  void processCameraImage(CameraImage image) async {
    if (interpreter == null || isDetecting) return;
    isDetecting = true;

    try {
      // Gabungkan semua bytes dari citra kamera
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      // Ambil orientasi kamera
      final rotation = InputImageRotationValue.fromRawValue(
            cameraController!.description.sensorOrientation,
          ) ??
          InputImageRotation.rotation0deg;

      // Format input image
      final format = InputImageFormatValue.fromRawValue(image.format.raw);
      if (format == null) {
        debugPrint("❌ Format tidak didukung: ${image.format.raw}");
        isDetecting = false;
        return;
      }

      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: format,
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );

      // Deteksi pose
      final poses = await poseDetector.processImage(inputImage);
      if (poses.isEmpty) return;

      // Ambil keypoints dari pose pertama
      final List<double> keypoints = [];
      for (var lmType in PoseLandmarkType.values) {
        final lm = poses.first.landmarks[lmType];
        keypoints.addAll(lm != null ? [lm.x, lm.y, lm.z] : [0.0, 0.0, 0.0]);
      }

      // Pastikan format input ke model valid
      if (keypoints.length != 99) return;

      final input = [keypoints]; // shape [1, 99]
      final output =
          List.generate(1, (_) => List.filled(labels.length, 0.0)); // [1, 15]

      // Jalankan model
      interpreter!.run(input, output);
      final predictions = output[0];

      // Prediksi label
      final maxIndex =
          predictions.indexWhere((e) => e == predictions.reduce(max));
      if (maxIndex < 0 || maxIndex >= labels.length) return;

      final predicted = labels[maxIndex];

      // Evaluasi kebenaran berdasarkan label pilihan user
      if (predicted == selectedMovementTarget.value) {
        predictionCounter.update(predicted, (val) => val + 1,
            ifAbsent: () => 1);
      } else {
        predictionCounter.clear();
      }

      final count = predictionCounter[predicted] ?? 0;
      final isCorrect = count >= correctThreshold;

      predictedLabel.value =
          "$predicted - ${isCorrect ? "✅ Sudah Benar" : "❌ Belum Benar"}";
      debugPrint(
          "🎯 Target: $selectedMovementTarget.value | Predicted: $predicted | Count: $count");
    } catch (e) {
      debugPrint("❌ Pose detection error: $e");
    } finally {
      isDetecting = false;
    }
  }

  Future<void> initializeCamera() async {
    try {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);

      final cameras = await availableCameras();
      final frontCam = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front,
      );

      cameraController = CameraController(
        frontCam,
        ResolutionPreset.medium,
        enableAudio: false, // biasakan disable audio jika tak perlu
        imageFormatGroup: ImageFormatGroup.nv21,
      );

      await cameraController!.initialize();
      await cameraController!.startImageStream(processCameraImage);
      isCameraInitialized.value = true;
      update(); // trigger GetBuilder / Obx jika ada
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  // Dispose kamera saat keluar dari halaman
  void disposeCamera() {
    cameraController?.dispose();
    cameraController = null;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
