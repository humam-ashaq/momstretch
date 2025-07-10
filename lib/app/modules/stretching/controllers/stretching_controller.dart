import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../views/stretching_detail_sheet.dart';

class StretchingController extends GetxController {
  Interpreter? interpreter;
  List<String> labels = [];
  CameraController? cameraController;
  List<CameraDescription> cameras = [];
  int selectedCameraIndex = 0;
  var isCameraInitialized = false.obs;
  final poseDetector = PoseDetector(
    options: PoseDetectorOptions(mode: PoseDetectionMode.stream),
  );
  bool isDetecting = false;
  final Map<String, int> predictionCounter = {};
  static const int correctThreshold = 5; // Jumlah deteksi berturut-turut untuk dianggap "benar"
  final RxString predictedLabel = ''.obs; // Untuk tampilan UI

  @override
  void onInit() {
    super.onInit();
    if (selectedProgram.value == null && programList.isNotEmpty) {
      selectedProgram.value = programList.first; // atau nilai default lain
    }
    loadModel();
  }

  @override
  void onClose() {
    cameraController?.stopImageStream();
    cameraController?.dispose();
    interpreter?.close();
    super.onClose();
  }

  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset(
          'assets/models/model.tflite');


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
    final output = List.generate(1, (_) => List.filled(labels.length, 0.0)); // [1, 15]

    // Jalankan model
    interpreter!.run(input, output);
    final predictions = output[0];

    // Prediksi label
    final maxIndex = predictions.indexWhere((e) => e == predictions.reduce(max));
    if (maxIndex < 0 || maxIndex >= labels.length) return;

    final predicted = labels[maxIndex];

    // Evaluasi kebenaran berdasarkan label pilihan user
    if (predicted == selectedMovement) {
      predictionCounter.update(predicted, (val) => val + 1, ifAbsent: () => 1);
    } else {
      predictionCounter.clear();
    }

    final count = predictionCounter[predicted] ?? 0;
    final isCorrect = count >= correctThreshold;

    predictedLabel.value = "$predicted - ${isCorrect ? "✅ Sudah Benar" : "❌ Belum Benar"}";
    debugPrint("🎯 Target: $selectedMovement | Predicted: $predicted | Count: $count");
  } catch (e) {
    debugPrint("❌ Pose detection error: $e");
  } finally {
    isDetecting = false;
  }
}



  // List stretching yang tersedia
  final stretchingList = <Map<String, String>>[
    {
      'image': 'assets/images/pose2.png',
      'title': 'Senam Nifas',
      'level': 'Pemula',
      'duration': '23 menit',
    },
    {
      'image': 'assets/images/pose1.png',
      'title': 'Senam Diastasis Recti',
      'level': 'Pemula',
      'duration': '20 menit',
    },
  ].obs;

  final selectedProgram = RxnString(); // Melahirkan Normal / Caesar
  final selectedStretching =
      Rxn<Map<String, String>>(); // Detail stretching yang dipilih
  final selectedMovement =
      Rxn<Map<String, String>>(); // Detail gerakan yang dipilih

  final List<String> programList = [
    'Persalinan Normal',
    'Persalinan Operasi Caesar',
  ];

  final Map<String, List<Map<String, String>>> movementsByStretchingType = {
    'Senam Nifas': [
      {
        'image': 'assets/images/yoga.png',
        'title': 'Slide Out',
        'description': '''
# Gerakan 1
Slide Out:
- Duduk bersila di lantai
- Kemudian posisikan satu tangan di perut dan satu tangan lagi di lantai, sambil memegang handuk kecil
- Sambil Tarik nafas, dorong tangan anda yang sedang memegang handuk ke arah samping
- Lalu sambil buang napas dan kempiskan perut, Tarik tangan anda ke posisi semula
- Ulangi Gerakan ini 3 × 10 hingga 12 repetisi pada masing-masing sisi tangan
        ''',
      },
      {
        'image': 'assets/images/yoga.png',
        'title': 'Pelvic Tilts',
        'description': '''
# Gerakan 1
Slide Out:
- Duduk bersila di lantai
- Kemudian posisikan satu tangan di perut dan satu tangan lagi di lantai, sambil memegang handuk kecil
- Sambil Tarik nafas, dorong tangan anda yang sedang memegang handuk ke arah samping
- Lalu sambil buang napas dan kempiskan perut, Tarik tangan anda ke posisi semula
- Ulangi Gerakan ini 3 × 10 hingga 12 repetisi pada masing-masing sisi tangan
        ''',
      },
      {
        'image': 'assets/images/yoga.png',
        'title': 'Heel Slides',
        'description': '''
# Gerakan 1
Slide Out:
- Duduk bersila di lantai
- Kemudian posisikan satu tangan di perut dan satu tangan lagi di lantai, sambil memegang handuk kecil
- Sambil Tarik nafas, dorong tangan anda yang sedang memegang handuk ke arah samping
- Lalu sambil buang napas dan kempiskan perut, Tarik tangan anda ke posisi semula
- Ulangi Gerakan ini 3 × 10 hingga 12 repetisi pada masing-masing sisi tangan
        ''',
      },
    ],
    'Senam Diastasis Recti': [
      {
        'image': 'assets/images/yoga.png',
        'title': 'Butterfly Stretch',
        'description': '''
# Gerakan 1
Slide Out:
- Duduk bersila di lantai
- Kemudian posisikan satu tangan di perut dan satu tangan lagi di lantai, sambil memegang handuk kecil
- Sambil Tarik nafas, dorong tangan anda yang sedang memegang handuk ke arah samping
- Lalu sambil buang napas dan kempiskan perut, Tarik tangan anda ke posisi semula
- Ulangi Gerakan ini 3 × 10 hingga 12 repetisi pada masing-masing sisi tangan
        ''',
      },
      {
        'image': 'assets/images/yoga.png',
        'title': 'Hip Opener',
        'description': '''
# Gerakan 1
Slide Out:
- Duduk bersila di lantai
- Kemudian posisikan satu tangan di perut dan satu tangan lagi di lantai, sambil memegang handuk kecil
- Sambil Tarik nafas, dorong tangan anda yang sedang memegang handuk ke arah samping
- Lalu sambil buang napas dan kempiskan perut, Tarik tangan anda ke posisi semula
- Ulangi Gerakan ini 3 × 10 hingga 12 repetisi pada masing-masing sisi tangan
        ''',
      },
    ],
  };

  List<Map<String, String>> get movementsForSelectedStretching {
    final title = selectedStretching.value?['title'];
    return movementsByStretchingType[title] ?? [];
  }

  String getProgramDescription(String program) {
    switch (program) {
      case 'Persalinan Normal':
        return '''
🌞 Untuk persalinan normal:
Mulai 1–2 hari pasca melahirkan (jika tidak ada komplikasi).

Durasi:
✅ 10–20 menit per sesi, 1–2 kali sehari.

Fokus pada:
Pernapasan dalam  
Senam Kegel (melatih otot dasar panggul)  
Peregangan ringan
''';
      case 'Persalinan Operasi Caesar':
        return '''
🌸 Untuk persalinan Caesar:
Mulai setelah dokter mengizinkan (umumnya 4–6 minggu pasca operasi).

Durasi:
✅ 5–15 menit per sesi, 1 kali sehari.

Fokus pada:
Pemulihan luka operasi  
Peregangan lembut  
Perkuatan otot dasar panggul secara bertahap
''';
      default:
        return 'Deskripsi belum tersedia untuk program ini.';
    }
  }

  void goToStretchingDetail(Map<String, String> stretching) {
    selectedStretching.value = stretching;
    Get.toNamed('/stretching-detail');
  }

  void showMovementDetail(Map<String, String> movement) {
    selectedMovement.value = movement;
    Get.bottomSheet(
      const StretchingDetailSheet(),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    );
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

  void goToStretchingCamera() async {
    await initializeCamera(); // pastikan kamera siap sebelum pindah
    Get.toNamed('/stretching-cam');
  }
}
