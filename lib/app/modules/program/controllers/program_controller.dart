import 'package:get/get.dart';

class ProgramController extends GetxController {
  final selectedProgram = RxnString();

  final List<String> programList = [
    'Melahirkan Normal',
    'Melahirkan Operasi Caesar',
  ];
}
