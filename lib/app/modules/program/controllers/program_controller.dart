import 'package:get/get.dart';
import 'package:mom_stretch/app/services/auth_service.dart';

class ProgramController extends GetxController {
  final RxnString selectedProgram = RxnString();

  void selectProgram(String program) {
    selectedProgram.value = program;
  }

  Future<void> updateProgram() async {
    final result = await AuthService.updateProgram(
      selectedProgram.string,
    );
    if (result['success']) {
      Get.snackbar('Sukses', result['message']);
      await Future.delayed(Duration(seconds: 1));
      Get.offAllNamed('/main'); // Kalau sudah login, ke halaman home
    } else {
      Get.snackbar('Error', result['message']);
    }
  }
}
