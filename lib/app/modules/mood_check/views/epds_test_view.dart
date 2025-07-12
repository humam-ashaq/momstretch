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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: const Offset(0, 1),
              blurRadius: 1,
              spreadRadius: 1,
            )
          ]),
          child: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.fromLTRB(12, 30, 12, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.primaryColor,
                    ),
                    onPressed: () => Get.back(),
                  ),
                  Text(
                    'MOMSTRETCH+',
                    style: TextStyle(
                      letterSpacing: 2,
                      fontFamily: 'HammersmithOne',
                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                      color: Color.fromARGB(1000, 235, 203, 143),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.transparent,
                    ),
                    onPressed: () {
                      // Get.to(() => ProfileEditView());
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
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
            'Tes EPDS',
            style: TextStyle(fontSize: 24, color: AppColors.primaryColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8,),
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor),
                    ),
                    ...List.generate((question['options'] as List).length,
                        (optIndex) {
                      final option = question['options'][optIndex];
                      return Obx(() => RadioListTile(
                            title: Text(option['text'],
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                )),
                            value: optIndex,
                            groupValue: controller.answers[index],
                            activeColor: AppColors.primaryColor,
                            fillColor: WidgetStateProperty.resolveWith<Color>(
                              (states) {
                                if (states.contains(WidgetState.selected)) {
                                  return AppColors
                                      .primaryColor; // isi lingkaran saat dipilih
                                }
                                return Colors
                                    .grey; // warna lingkaran saat tidak dipilih
                              },
                            ),
                            onChanged: (val) =>
                                controller.setAnswer(index, val as int),
                          ));
                    }),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor),
            onPressed: controller.allAnswered ? controller.submitAnswers : null,
            child: const Text(
              'Kirim',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
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
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor),
            onPressed: () => Get.offNamed('/main'),
            child: const Text(
              'Kembali',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
