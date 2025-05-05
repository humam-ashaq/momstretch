import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/article_controller.dart';
import 'package:mom_stretch/app/data/app_colors.dart';

class ArticleView extends GetView<ArticleController> {
  const ArticleView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.primaryColor,),
                onPressed: () => Get.back(),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/pilihprogram.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Bunda, ini yang Terjadi pada Dirimu Sesudah Melahirkan',
                style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Cillum laborum laborum excepteur commodo proident dolore labore esse sunt magna laborum eiusmod sint.',
                style: const TextStyle(fontSize: 16, color: AppColors.primaryColor),
              ),
              const SizedBox(height: 24),
              const Text(
                // Konten placeholder
                '''Cillum laboris et deserunt fugiat officia elit sunt ut commodo magna sit nulla duis ea. Proident dolore fugiat nisi labore nisi nulla eu nisi veniam cupidatat qui elit officia. Ullamco veniam irure sunt eiusmod magna enim minim ipsum aliqua et consectetur incididunt. Ad ut cillum enim ipsum est. Consectetur fugiat Lorem eu duis velit. Lorem ad laboris ad culpa ipsum.

Laborum nulla eu qui laboris consectetur do proident nulla sit veniam consectetur velit. Duis labore incididunt ex consectetur irure irure esse non velit magna. Minim magna irure duis sint ad dolor commodo minim esse aliqua. Culpa ad deserunt ea voluptate. Aliqua ullamco minim elit laborum ad quis. Incididunt tempor duis fugiat velit dolore excepteur exercitation ullamco amet. Deserunt nisi officia in anim.

Culpa consectetur excepteur duis excepteur qui enim deserunt ullamco incididunt qui ea laborum exercitation consectetur. Nisi voluptate duis ut excepteur voluptate labore incididunt proident consectetur ullamco. Deserunt et non minim exercitation nisi culpa anim commodo sunt. Excepteur sunt enim irure commodo fugiat velit id minim ea velit aliquip adipisicing.

Excepteur Lorem occaecat duis in. Fugiat incididunt excepteur deserunt sit. Dolor ullamco consectetur aliquip amet elit duis consequat consectetur. Sit aliquip culpa consequat et. Ut velit irure nulla deserunt qui non nulla eiusmod nulla veniam occaecat elit.''',
                style: TextStyle(fontSize: 14, height: 1.6, color: AppColors.primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
