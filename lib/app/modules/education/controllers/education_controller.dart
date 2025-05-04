import 'package:get/get.dart';

class EducationController extends GetxController {
  
  @override
  void onInit() {
    super.onInit();
  }
  
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

  final selectedEducation = Rxn<Map<String, String>>();

  void onEducationTap(int index) {
    selectedEducation.value = educations[index];
    Get.toNamed('/education-detail');
  }
}