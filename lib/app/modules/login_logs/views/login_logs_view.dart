// modules/history/history_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mom_stretch/app/modules/login_logs/controllers/login_logs_controller.dart';

class LoginLogsView extends GetView<LoginLogsController> {
  const LoginLogsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Login')),
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
