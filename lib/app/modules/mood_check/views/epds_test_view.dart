import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mom_stretch/app/data/app_colors.dart';
import 'package:mom_stretch/app/modules/mood_check/controllers/mood_check_controller.dart';

class EpdsTestView extends GetView<MoodCheckController> {
  const EpdsTestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Tes EPDS', style: TextStyle(
        color: AppColors.primaryColor
      ),), backgroundColor: Colors.white,),
      body: SafeArea(
        child: Obx(() => controller.isSubmitted.value
            ? _buildResult(controller)
            : _buildAllQuestions(controller)),
      ),
    );
  }

  Widget _buildAllQuestions(MoodCheckController controller) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Pilih jawaban yang paling dekat dengan perasaan Anda dalam 7 hari terakhir:',
            style: TextStyle(fontSize: 14, color: AppColors.primaryColor),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: controller.epdsQuestions.length,
              itemBuilder: (context, index) {
                final question = controller.epdsQuestions[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${index + 1}. ${question['question']}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                    ),
                    ...List.generate((question['options'] as List).length,
                        (optIndex) {
                      final option = question['options'][optIndex];
                      return Obx(() => RadioListTile(
                            title: Text(option['text'], style: TextStyle(color: AppColors.primaryColor,)),
                            value: optIndex,
                            groupValue: controller.answers[index],
                            onChanged: (val) => controller.setAnswer(index, val as int),
                          ));
                    }),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: controller.allAnswered
                ? controller.submitAnswers
                : null,
            child: const Text('Kirim'),
          ),
        ],
      ),
    );
  }

  Widget _buildResult(MoodCheckController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Skor Anda: ${controller.epdsScore.value}',
              style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 8),
          Text(controller.epdsResult, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Get.offNamed('/main'),
            child: const Text('Kembali'),
          ),
        ],
      ),
    );
  }
}
