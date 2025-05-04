import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mom_stretch/app/modules/mood_check/controllers/mood_check_controller.dart';

class EpdsOnboardingView extends GetView<MoodCheckController> {
  const EpdsOnboardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pages = [
      _OnboardingPage(
        imagePath: 'assets/images/epds1.png',
        title: 'EPDS',
        subtitle: '(Deteksi resiko terkena baby blues)',
        description:
            'Kuesioner ini disebut Edinburgh Postnatal Skala Depresi (EDP) EDP dikembangkan untuk mengidentifikasi wanita yang mungkin memiliki postpartum depresi.',
        isLast: false,
      ),
      _OnboardingPage(
        imagePath: 'assets/images/epds2.png',
        title: 'EPDS',
        subtitle: '(Deteksi resiko terkena baby blues)',
        description: 'Setiap jawaban diberikan skor 0 hingga 3. Maksimum skor adalah 30.',
        isLast: false,
      ),
      _OnboardingPage(
        imagePath: 'assets/images/epds3.png',
        title: 'EPDS',
        subtitle: '(Deteksi resiko terkena baby blues)',
        description: 'AYO MULAI',
        isLast: true,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: pages.length,
                itemBuilder: (_, index) => pages[index],
              ),
            ),
            Obx(() => _BottomNavigation(
              currentIndex: controller.currentPage.value,
              onNext: controller.nextPage,
              onBack: controller.previousPage,
              isLast: controller.currentPage.value == pages.length - 1,
            )),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String description;
  final bool isLast;

  const _OnboardingPage({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.description,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 32),
        Image.asset(imagePath, height: 280),
        const SizedBox(height: 20),
        Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final bool isLast;

  const _BottomNavigation({
    required this.currentIndex,
    required this.onNext,
    required this.onBack,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          TextButton(onPressed: onBack, child: const Text('BACK')),
          const Spacer(),
          Row(
            children: List.generate(3, (index) {
              final isActive = index == currentIndex;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: isActive ? Colors.brown : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
          const Spacer(),
          TextButton(
            onPressed: onNext,
            child: Text(isLast ? 'MULAI' : 'NEXT'),
          ),
        ],
      ),
    );
  }
}
