import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/program_controller.dart';

class ProgramView extends GetView<ProgramController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Program Stretching',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
              const Text("Mari mulai dengan menentukan\nProgram Stretching"),
              const SizedBox(height: 12),
              Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedProgram.value,
                    decoration: InputDecoration(
                      hintText: "Pilih Program Stretching",
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: controller.programList.map((program) {
                      return DropdownMenuItem(
                        value: program,
                        child: Text(program),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.selectedProgram.value = value;
                    },
                  )),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: "Usia",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.offAllNamed('/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF52463B),
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'KONFIRMASI',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
