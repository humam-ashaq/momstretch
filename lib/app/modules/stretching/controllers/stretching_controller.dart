import 'package:get/get.dart';

class StretchingController extends GetxController {
  //nanti ambil dari database
  final stretchingList = <Map<String, String>>[
    {
      'image': 'assets/images/pose2.png',
      'title': 'Senam Perut',
      'level': 'Beginner',
      'duration': '23 min',
    },
    {
      'image': 'assets/images/pose1.png',
      'title': 'Pose Kupu-Kupu',
      'level': 'Beginner',
      'duration': '23 min',
    },
    {
      'image': 'assets/images/pose2.png',
      'title': 'Senam Perut',
      'level': 'Beginner',
      'duration': '23 min',
    },
    {
      'image': 'assets/images/pose1.png',
      'title': 'Pose Kupu-Kupu',
      'level': 'Beginner',
      'duration': '23 min',
    },
    {
      'image': 'assets/images/pose2.png',
      'title': 'Senam Perut',
      'level': 'Beginner',
      'duration': '23 min',
    },
    {
      'image': 'assets/images/pose1.png',
      'title': 'Pose Kupu-Kupu',
      'level': 'Beginner',
      'duration': '23 min',
    },
  ].obs;

  final selectedProgram = RxnString();

  final List<String> programList = [
    'Melahirkan Normal',
    'Melahirkan Operasi Caesar',
  ];
}
