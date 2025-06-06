import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mom_stretch/app/data/app_colors.dart';
import '../controllers/program_controller.dart';

class ProgramView extends GetView<ProgramController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Center(
                child: Text(
                  'MOMSTRETCH+',
                  style: TextStyle(
                    letterSpacing: 2,
                    fontFamily: 'HammersmithOne',
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                    color: Color.fromARGB(1000, 235, 203, 143),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Pilih Program\nStretchingmu',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 32),
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _ProgramOption(
                      label: 'Persalinan Normal',
                      imageAsset: 'assets/images/normal.png',
                      isSelected: controller.selectedProgram.value == 'normal',
                      onTap: () => controller.selectProgram('normal'),
                    ),
                    _ProgramOption(
                      label: 'Persalinan Caesar',
                      imageAsset: 'assets/images/caesar.png',
                      isSelected: controller.selectedProgram.value == 'caesar',
                      onTap: () => controller.selectProgram('caesar'),
                    ),
                  ],
                );
              }),
              const Spacer(),
              Obx(() {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.selectedProgram.value != null
                        ? controller.updateProgram
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Pilih Program Stretching',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgramOption extends StatelessWidget {
  final String label;
  final String imageAsset;
  final bool isSelected;
  final VoidCallback onTap;

  const _ProgramOption({
    required this.label,
    required this.imageAsset,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        height: 240,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEADFCF) : const Color(0xFFD2C1B2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imageAsset,
              width: 100,
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
