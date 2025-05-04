import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoodCheckController extends GetxController {
  // nanti diganti dari database
  RxInt epdsScore = 0.obs;

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

  //onboarding epds
  var currentPage = 0.obs;
  late PageController pageController;

  Timer? _timer;

  void nextPage() {
    if (currentPage.value < 2) {
      pageController.nextPage(
          duration: 300.milliseconds, curve: Curves.easeInOut);
    } else {
      Get.toNamed('/epds-test');
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: 300.milliseconds,
        curve: Curves.easeInOut,
      );
    } else {
      Get.back();
      Get.back(); // kembali ke halaman sebelumnya di aplikasi
    }
  }

  void onPageChanged(int index) {
    currentPage.value = index;
    _startAutoAdvance(index);
  }

  void _startAutoAdvance(int pageIndex) {
    _timer?.cancel(); // clear timer sebelumnya

    if (pageIndex < 2) {
      _timer = Timer(4.seconds, () {
        if (currentPage.value == pageIndex) {
          nextPage(); // hanya auto-next jika user masih di halaman yang sama
        }
      });
    }
  }

  @override
  void onInit() {
    super.onInit();
    currentPage.value = 0;

    // Atur posisi awal PageController secara eksplisit
    pageController = PageController(initialPage: 0);

    pageController.addListener(() {
      final newPage = pageController.page?.round() ?? 0;
      if (currentPage.value != newPage) {
        currentPage.value = newPage;
        _startAutoAdvance(newPage);
      }
    });

    _startAutoAdvance(0);
  }

  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }

  //epds test
  // Tambahkan dalam MoodCheckController
  final List<Map<String, dynamic>> epdsQuestions = [
    {
      'question': 'Saya bisa tertawa dan melihat sisi lucu dari sesuatu.',
      'options': [
        {'text': 'Sebagaimana biasa', 'score': 0},
        {'text': 'Agak kurang dari biasanya', 'score': 1},
        {'text': 'Jelas kurang dari biasanya', 'score': 2},
        {'text': 'Sama sekali tidak bisa', 'score': 3},
      ],
    },
    {
      'question': 'Saya menantikan sesuatu dengan gembira.',
      'options': [
        {'text': 'Sebagaimana biasa', 'score': 0},
        {'text': 'Agak kurang dari biasanya', 'score': 1},
        {'text': 'Jelas kurang dari biasanya', 'score': 2},
        {'text': 'Hampir tidak pernah', 'score': 3},
      ],
    },
    {
      'question':
          'Saya menyalahkan diri sendiri tanpa alasan bila ada yang tidak berjalan dengan baik.',
      'options': [
        {'text': 'Tidak, tidak pernah', 'score': 0},
        {'text': 'Jarang sekali', 'score': 1},
        {'text': 'Kadang-kadang', 'score': 2},
        {'text': 'Ya, hampir selalu', 'score': 3},
      ],
    },
    {
      'question': 'Saya merasa cemas atau khawatir tanpa alasan yang jelas.',
      'options': [
        {'text': 'Tidak, tidak pernah', 'score': 0},
        {'text': 'Jarang', 'score': 1},
        {'text': 'Kadang-kadang', 'score': 2},
        {'text': 'Ya, sangat sering', 'score': 3},
      ],
    },
    {
      'question': 'Saya merasa takut atau panik tanpa alasan yang baik.',
      'options': [
        {'text': 'Tidak, tidak pernah', 'score': 0},
        {'text': 'Jarang', 'score': 1},
        {'text': 'Kadang-kadang', 'score': 2},
        {'text': 'Ya, sangat sering', 'score': 3},
      ],
    },
    {
      'question': 'Segalanya terasa menumpuk dan membuat saya kewalahan.',
      'options': [
        {'text': 'Tidak, saya dapat mengatasi seperti biasa', 'score': 0},
        {
          'text': 'Ya, sebagian besar waktu saya dapat mengatasi dengan baik',
          'score': 1
        },
        {
          'text': 'Tidak, saya kesulitan mengatasi seperti biasanya',
          'score': 2
        },
        {'text': 'Tidak, saya tidak bisa mengatasinya sama sekali', 'score': 3},
      ],
    },
    {
      'question': 'Saya merasa tidak bahagia hingga sulit tidur.',
      'options': [
        {'text': 'Tidak, tidak pernah', 'score': 0},
        {'text': 'Jarang', 'score': 1},
        {'text': 'Cukup sering', 'score': 2},
        {'text': 'Hampir sepanjang waktu', 'score': 3},
      ],
    },
    {
      'question': 'Saya merasa sedih atau putus asa.',
      'options': [
        {'text': 'Tidak, tidak pernah', 'score': 0},
        {'text': 'Jarang', 'score': 1},
        {'text': 'Cukup sering', 'score': 2},
        {'text': 'Hampir sepanjang waktu', 'score': 3},
      ],
    },
    {
      'question': 'Saya merasa tidak berharga sebagai ibu.',
      'options': [
        {'text': 'Tidak, tidak pernah', 'score': 0},
        {'text': 'Jarang', 'score': 1},
        {'text': 'Cukup sering', 'score': 2},
        {'text': 'Hampir sepanjang waktu', 'score': 3},
      ],
    },
    {
      'question':
          'Pikiran untuk menyakiti diri sendiri pernah terlintas di benak saya.',
      'options': [
        {'text': 'Tidak pernah', 'score': 0},
        {'text': 'Hampir tidak pernah', 'score': 1},
        {'text': 'Kadang-kadang', 'score': 2},
        {'text': 'Cukup sering', 'score': 3},
      ],
    },
  ];

  // Jawaban untuk setiap pertanyaan, -1 artinya belum dijawab
  RxList<int> answers = List.generate(10, (_) => -1).obs;

// Status: apakah sudah disubmit
  RxBool isSubmitted = false.obs;

// Apakah semua sudah dijawab?
  bool get allAnswered => !answers.contains(-1);

// Simpan jawaban
  void setAnswer(int questionIndex, int selectedOptionIndex) {
    answers[questionIndex] = selectedOptionIndex;
  }

// Hitung skor dan tandai sebagai selesai
  void submitAnswers() {
    int total = 0;
    for (int i = 0; i < epdsQuestions.length; i++) {
      final score =
          (epdsQuestions[i]['options'] as List)[answers[i]]['score'] as int;
      total += score;
    }
    epdsScore.value = total;
    isSubmitted.value = true;
  }
}
