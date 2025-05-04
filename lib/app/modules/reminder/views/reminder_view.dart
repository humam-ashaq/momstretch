// reminder_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mom_stretch/app/data/app_colors.dart';
import '../controllers/reminder_controller.dart';

class ReminderView extends GetView<ReminderController> {
  const ReminderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            const Icon(Icons.notifications_active, size: 100, color: AppColors.primaryColor),
            const SizedBox(height: 20),
            const Text(
              'Jangan Lupa Stretching!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor),
            ),
            const Text(
              'Luangkan waktu sebentar\nuntuk melakukan stretching\npada hari ini.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.primaryColor),
            ),
            const Spacer(),
            Obx(() {
              final time = controller.time.value;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                color: Colors.grey.shade200,
                child: Row(
                  children: [
                    Text('${time.format(context)}',
                        style: const TextStyle(fontSize: 28, color: AppColors.primaryColor)),
                    const SizedBox(width: 8),
                    const Text('setiap hari'),
                    const Spacer(),
                    Obx(() => Switch(
                      value: controller.isEnabled.value,
                      onChanged: controller.toggleReminder,
                    )),
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: controller.time.value,
                );
                if (picked != null) controller.updateTime(picked);
              },
              child: const Text(
                'Ubah Waktu Pengingat',
                style: TextStyle(
                  color: AppColors.tertiaryColor
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
