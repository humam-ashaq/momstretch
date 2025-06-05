import 'package:get/get.dart';

class ProgramController extends GetxController {
  final RxnString selectedProgram = RxnString();

  void selectProgram(String program) {
    selectedProgram.value = program;
  }
}
