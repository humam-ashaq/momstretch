import 'package:get/get.dart';

import '../controllers/mood_check_controller.dart';

class MoodCheckBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MoodCheckController>(
      () => MoodCheckController(),
    );
  }
}
