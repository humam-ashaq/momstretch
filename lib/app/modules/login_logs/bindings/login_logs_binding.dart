import 'package:get/get.dart';

import '../controllers/login_logs_controller.dart';

class LoginLogsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginLogsController>(
      () => LoginLogsController(),
    );
  }
}
