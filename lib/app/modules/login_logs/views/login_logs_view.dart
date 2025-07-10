// modules/history/history_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mom_stretch/app/modules/login_logs/controllers/login_logs_controller.dart';
import '../../../data/app_colors.dart';

class LoginLogsView extends GetView<LoginLogsController> {
  const LoginLogsView({super.key});

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
                      Icons.add_chart,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.historyList.isEmpty) {
          return const Center(child: Text('Belum ada riwayat login'));
        }

        return ListView.builder(
          itemCount: controller.historyList.length,
          itemBuilder: (context, index) {
            final item = controller.historyList[index];
            return ListTile(
              leading: const Icon(Icons.login),
              title: Text(item.timestamp),
              subtitle: Text('Device: ${item.device}\nIP: ${item.ip}'),
            );
          },
        );
      }),
    );
  }
}