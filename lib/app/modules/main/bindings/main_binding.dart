import 'package:get/get.dart';

import '../../education/controllers/education_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../mood_check/controllers/mood_check_controller.dart';
import '../../stretching/controllers/stretching_controller.dart';
import '../controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => StretchingController());
    Get.lazyPut(() => EducationController());
    Get.lazyPut(() => MoodCheckController());
  }
}

