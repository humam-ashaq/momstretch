import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../education/views/education_view.dart';
import '../../home/views/home_view.dart';
import '../../stretching/views/stretching_view.dart';

class MainController extends GetxController {
  final List<Widget> pages = [
    HomeView(),
    StretchingView(),
    EducationView(),
    // ProfileView(),
  ];
  var currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }
}
