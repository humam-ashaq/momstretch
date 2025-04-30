import 'package:get/get.dart';

class EducationController extends GetxController {
  final List<Map<String, String>> educations = [
    {
      'title': 'Postpartum Diet',
      'subtitle': 'Gimana si cara diet after melahirkan?',
      'image': 'assets/images/pilihprogram.png',
    },
    {
      'title': 'Menangani Stres',
      'subtitle': 'Gimana si cara diet after melahirkan?',
      'image': 'assets/images/pilihprogram.png',
    },
    {
      'title': 'Postpartum Diet',
      'subtitle': 'Gimana si cara diet after melahirkan?',
      'image': 'assets/images/pilihprogram.png',
    },
    {
      'title': 'Menangani Stres',
      'subtitle': 'Gimana si cara diet after melahirkan?',
      'image': 'assets/images/pilihprogram.png',
    },
    {
      'title': 'Postpartum Diet',
      'subtitle': 'Gimana si cara diet after melahirkan?',
      'image': 'assets/images/pilihprogram.png',
    },
    {
      'title': 'Postpartum Diet',
      'subtitle': 'Gimana si cara diet after melahirkan?',
      'image': 'assets/images/pilihprogram.png',
    },
  ];

  void onEducationTap(int index) {
    Get.toNamed('/education-detail', arguments: educations[index]);
  }
}
