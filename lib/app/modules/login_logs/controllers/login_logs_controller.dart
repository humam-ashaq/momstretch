// modules/history/history_controller.dart
import 'package:get/get.dart';
import '../../../../models/login_history_model.dart';
import '../../../services/auth_service.dart';

class LoginLogsController extends GetxController {
  var isLoading = false.obs;
  var historyList = <LoginHistory>[].obs;

  @override
  void onInit() {
    fetchHistory();
    super.onInit();
  }

  void fetchHistory() async {
    try {
      isLoading.value = true;
      final list = await AuthService.fetchLoginHistory();
      historyList.value = list;
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil riwayat login');
    } finally {
      isLoading.value = false;
    }
  }
}
