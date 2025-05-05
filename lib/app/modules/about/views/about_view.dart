import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mom_stretch/app/data/app_colors.dart';

import '../controllers/about_controller.dart';

class AboutView extends GetView<AboutController> {
  const AboutView({super.key});
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
              padding: const EdgeInsets.fromLTRB(8, 30, 8, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.primaryColor,
                    ),
                    onPressed: () => Get.back(),
                  ),
                  Text(
                    'Tentang',
                    style: TextStyle(
                      letterSpacing: 2,
                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const Spacer(),
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
                ],
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ExpansionTile(
            leading: Icon(Icons.phone, color: AppColors.primaryColor),
            title: Text('Kontak Kami',
                style: TextStyle(color: AppColors.primaryColor)),
            children: [
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: AppColors.forthColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Jika Anda mengalami kendala atau ada pertanyaan lainnya terkait penggunaan aplikasi MOMSTRETCH+, Anda dapat menghubungi:',
                    ),
                    SizedBox(height: 8),
                    Text('Whatsapp: +62 823-2736-5875',
                        style: TextStyle(color: Colors.blue)),
                    Text('Email: capstone17b@gmail.com',
                        style: TextStyle(color: Colors.blue)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ExpansionTile(
            leading: Icon(Icons.info_outline, color: AppColors.primaryColor),
            title: Text('Info Aplikasi',
                style: TextStyle(color: AppColors.primaryColor)),
            children: [
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: AppColors.forthColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'MOMSTRETCH+ merupakan aplikasi yang dibuat untuk membantu para ibu nifas dalam melakukan senam/peregangan ibu nifas secara mandiri, kapan pun dan di mana pun. MOMSTRETCH+ dapat mendampingi bunda selayaknya instruktur senam/peregangan ibu nifas.'
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
