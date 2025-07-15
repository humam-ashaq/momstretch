import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/epds_service.dart';

class MoodCheckController extends GetxController {
  // Data utama
  var isLoadingHistory = true.obs;
  RxList<int> epdsHistory = <int>[].obs;
  RxInt epdsScore = 0.obs;

  // State untuk Onboarding & Tes
  var currentPage = 0.obs;
  PageController? pageController;
  Timer? _timer;

  // Flag untuk memastikan tidak ada operasi pada controller yang sudah di-dispose
  bool isPageControllerActive = false;

  //epds test
  // Tambahkan dalam MoodCheckController
  final List<Map<String, dynamic>> epdsQuestions = [
    {
      "question": "Saya masih bisa tertawa dan menikmati hal-hal lucu.",
      "options": [
        {"text": "Sama seperti biasanya", "score": 0},
        {"text": "Tidak sesering biasanya", "score": 1},
        {"text": "Jauh berkurang dari biasanya", "score": 2},
        {"text": "Sama sekali tidak bisa", "score": 3}
      ]
    },
    {
      "question": "Saya bersemangat dalam menantikan atau menjalani sesuatu.",
      "options": [
        {"text": "Sama seperti biasanya", "score": 0},
        {"text": "Sedikit berkurang dari biasanya", "score": 1},
        {"text": "Jauh berkurang dari biasanya", "score": 2},
        {"text": "Hampir tidak pernah sama sekali", "score": 3}
      ]
    },
    {
      "question":
          "Ketika ada masalah, saya cenderung menyalahkan diri sendiri secara berlebihan.",
      "options": [
        {"text": "Tidak, sama sekali tidak", "score": 0},
        {"text": "Jarang sekali", "score": 1},
        {"text": "Ya, kadang-kadang", "score": 2},
        {"text": "Ya, hampir selalu", "score": 3}
      ]
    },
    {
      "question": "Saya merasa cemas dan khawatir tanpa sebab yang jelas.",
      "options": [
        {"text": "Tidak pernah", "score": 0},
        {"text": "Hampir tidak pernah", "score": 1},
        {"text": "Kadang-kadang", "score": 2},
        {"text": "Ya, sangat sering", "score": 3}
      ]
    },
    {
      "question":
          "Saya tiba-tiba merasa takut atau panik tanpa alasan yang kuat.",
      "options": [
        {"text": "Tidak, sama sekali tidak", "score": 0},
        {"text": "Tidak terlalu sering", "score": 1},
        {"text": "Ya, kadang-kadang", "score": 2},
        {"text": "Ya, cukup sering", "score": 3}
      ]
    },
    {
      "question":
          "Akhir-akhir ini, saya merasa semua hal menumpuk dan membuat saya kewalahan.",
      "options": [
        {
          "text": "Tidak, saya bisa mengatasi semuanya sebaik biasanya.",
          "score": 0
        },
        {
          "text": "Seringnya saya masih bisa mengatasi dengan cukup baik.",
          "score": 1
        },
        {
          "text": "Kadang saya kesulitan mengatasinya seperti biasa.",
          "score": 2
        },
        {"text": "Tidak, saya sama sekali tidak bisa mengatasinya.", "score": 3}
      ]
    },
    {
      "question": "Perasaan sedih atau tidak bahagia membuat saya sulit tidur.",
      "options": [
        {"text": "Tidak, sama sekali tidak", "score": 0},
        {"text": "Jarang sekali", "score": 1},
        {"text": "Ya, cukup sering", "score": 2},
        {"text": "Ya, hampir setiap saat", "score": 3}
      ]
    },
    {
      "question": "Saya merasa sedih atau murung.",
      "options": [
        {"text": "Tidak, sama sekali tidak", "score": 0},
        {"text": "Jarang sekali", "score": 1},
        {"text": "Ya, cukup sering", "score": 2},
        {"text": "Ya, hampir setiap saat", "score": 3}
      ]
    },
    {
      "question": "Saya merasa telah menjadi ibu yang gagal.",
      "options": [
        {"text": "Tidak, sama sekali tidak", "score": 0},
        {"text": "Jarang-jarang", "score": 1},
        {"text": "Ya, kadang-kadang", "score": 2},
        {"text": "Ya, hampir sepanjang waktu", "score": 3}
      ]
    },
    {
      "question":
          "Pernah terlintas di pikiran saya untuk menyakiti diri sendiri.",
      "options": [
        {"text": "Sama sekali tidak pernah", "score": 0},
        {"text": "Hampir tidak pernah", "score": 1},
        {"text": "Kadang-kadang terpikir", "score": 2},
        {"text": "Ya, cukup sering", "score": 3}
      ]
    }
  ];

  RxList<int> answers = List.generate(10, (_) => -1).obs;
  RxBool isSubmitted = false.obs;
  bool get allAnswered => !answers.contains(-1);

  @override
  void onInit() {
    super.onInit();
    fetchEpdsHistory();
  }

  void resetTest() {
    isPageControllerActive = true;
    currentPage.value = 0;
    pageController = PageController(initialPage: 0);

    pageController?.addListener(() {
      if (!isPageControllerActive ||
          pageController == null ||
          !pageController!.hasClients) return;
      final newPage = pageController!.page!.round();
      if (currentPage.value != newPage) {
        currentPage.value = newPage;
        _startAutoAdvance(newPage);
      }
    });

    _startAutoAdvance(0);
    answers.value = List.generate(10, (_) => -1);
    isSubmitted.value = false;
    epdsScore.value = 0;
  }

  void disposeOnboardingResources() {
    isPageControllerActive = false;
    _timer?.cancel();
    pageController?.dispose();
    // **STRATEGI BUMI HANGUS**
    // Hapus referensi objek setelah di-dispose.
    pageController = null;
  }

  @override
  void onClose() {
    isPageControllerActive = false;
    _timer?.cancel();
    pageController?.dispose();
    // **STRATEGI BUMI HANGUS**
    // Hapus referensi objek setelah di-dispose.
    pageController = null;
    super.onClose();
  }

  void _startAutoAdvance(int pageIndex) {
    _timer?.cancel();
    if (!isPageControllerActive)
      return; // Cek saklar sebelum membuat timer baru
    if (pageIndex < 2) {
      _timer = Timer(4.seconds, () {
        if (!isPageControllerActive || pageController == null) return;
        if (currentPage.value == pageIndex) {
          nextPage();
        }
      });
    }
  }

  void nextPage() {
    // Guard Clause yang lebih ketat
    if (!isPageControllerActive ||
        pageController == null ||
        !pageController!.hasClients) return;

    if (currentPage.value < 2) {
      pageController!
          .nextPage(duration: 300.milliseconds, curve: Curves.easeInOut);
    } else {
      Get.toNamed('/epds-test');
    }
  }

  void previousPage() {
    // Guard Clause yang lebih ketat
    if (!isPageControllerActive ||
        pageController == null ||
        !pageController!.hasClients) return;

    if (currentPage.value > 0) {
      pageController!.previousPage(
        duration: 300.milliseconds,
        curve: Curves.easeInOut,
      );
    } else {
      Get.back();
    }
  }

  void onPageChanged(int index) {
    if (!isPageControllerActive) return;
    currentPage.value = index;
    _startAutoAdvance(index);
  }

  // --- Fungsi-fungsi lain tidak berubah ---
  Future<void> fetchEpdsHistory() async {
    try {
      isLoadingHistory.value = true;
      final history = await EpdsService.fetchHistory();
      epdsHistory.value = history;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingHistory.value = false;
    }
  }

  String get epdsResult {
    if (epdsScore.value >= 13) {
      return 'Beresiko Tinggi Depresi';
    } else if (epdsScore.value >= 10) {
      return 'Berkemungkinan Depresi';
    } else if (epdsScore.value >= 1) {
      return 'Resiko Rendah';
    } else {
      return 'Anda belum mengisi EPDS minggu ini';
    }
  }

  void setAnswer(int questionIndex, int selectedOptionIndex) {
    answers[questionIndex] = selectedOptionIndex;
  }

  Future<void> submitAnswers() async {
    int total = 0;
    for (int i = 0; i < epdsQuestions.length; i++) {
      final score =
          (epdsQuestions[i]['options'] as List)[answers[i]]['score'] as int;
      total += score;
    }
    epdsScore.value = total;

    final result = await EpdsService.saveResult(total);

    if (result['success'] == true) {
      isSubmitted.value = true;
      await fetchEpdsHistory();
      Get.snackbar('Berhasil', result['message'] ?? 'Hasil telah disimpan.');
    } else {
      Get.snackbar('Gagal', result['message'] ?? 'Terjadi kesalahan.');
    }
  }
}
