import 'package:get/get.dart';

import '../controllers/visualization_controller.dart';

class VisualizationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VisualizationController>(
      () => VisualizationController(),
    );
  }
}
