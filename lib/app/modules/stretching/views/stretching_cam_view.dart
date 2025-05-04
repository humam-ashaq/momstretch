import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:mom_stretch/app/data/app_colors.dart';
import '../controllers/stretching_controller.dart';

class StretchingCamView extends GetView<StretchingController> {
  const StretchingCamView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controller.initializeCamera(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final movement = controller.selectedMovement.value;

          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Stack(
                children: [
                  // Kamera aktif
                  ClipRect(
                    child: SizedBox.expand(
                      child: OverflowBox(
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: controller
                                .cameraController!.value.previewSize!.width,
                            height: controller
                                .cameraController!.value.previewSize!.height,
                            child: CameraPreview(controller.cameraController!),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Header bar
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 288,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8))
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Tombol kembali
                              IconButton(
                                icon: const Icon(Icons.arrow_back,
                                    color: AppColors.forthColor),
                                onPressed: () {
                                  controller.disposeCamera();
                                  Get.back();
                                },
                              ),
                              // Info gerakan
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movement?['title'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: AppColors.forthColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'Posisikan tubuh sesuai contoh',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8,),
                        // Gambar contoh gerakan
                        Container(
                          margin: EdgeInsets.only(left: 16),
                          width: 256,
                          height: 144,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                              image: AssetImage(movement?['image'] ??
                                  'assets/images/default.png'),
                              fit: BoxFit.contain,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
