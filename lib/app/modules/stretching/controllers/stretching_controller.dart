import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../views/stretching_detail_sheet.dart';

class StretchingController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  // List stretching yang tersedia
  final stretchingList = <Map<String, String>>[
    {
      'image': 'assets/images/pose2.png',
      'title': 'Senam Perut',
      'level': 'Beginner',
      'duration': '23 menit',
    },
    {
      'image': 'assets/images/pose1.png',
      'title': 'Pose Kupu-Kupu',
      'level': 'Beginner',
      'duration': '20 menit',
    },
  ].obs;

  final selectedProgram = RxnString(); // Melahirkan Normal / Caesar
  final selectedStretching =
      Rxn<Map<String, String>>(); // Detail stretching yang dipilih
  final selectedMovement =
      Rxn<Map<String, String>>(); // Detail gerakan yang dipilih

  final List<String> programList = [
    'Melahirkan Normal',
    'Melahirkan Operasi Caesar',
  ];

  final Map<String, List<Map<String, String>>> movementsByStretchingType = {
    'Senam Perut': [
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
    'Pose Kupu-Kupu': [
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
      case 'Melahirkan Normal':
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
      case 'Melahirkan Operasi Caesar':
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

  //cam logic
  CameraController? cameraController;

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
      );

      await cameraController!.initialize();
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

  void goToStretchingCamera() async{
    await initializeCamera(); // pastikan kamera siap sebelum pindah
    Get.toNamed('/stretching-cam');
  }
}
