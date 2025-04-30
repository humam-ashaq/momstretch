import 'package:get/get.dart';

class MoodCheckController extends GetxController {
  // nanti diganti dari database
  RxInt epdsScore = 11.obs;

  String get epdsResult {
    if (epdsScore.value >= 13) {
      return 'High risk of depression';
    } else if (epdsScore.value >= 10) {
      return 'Possible depression';
    } else {
      return 'Low risk';
    }
  }

  // Dummy EPDS history data
  final List<int> epdsHistory = [3, 5, 6, 5, 7, 9, 8, 11, 13];
}
