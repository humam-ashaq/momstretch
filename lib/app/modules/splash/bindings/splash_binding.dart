import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    print('[SPLASH] Binding running');
    Get.lazyPut<SplashController>(() => SplashController());
  }
}
