import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/stretching_controller.dart';

class StretchingView extends GetView<StretchingController> {
  const StretchingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'MOMSTRETCH+',
                    style: TextStyle(
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.amber[700],
                    ),
                  ),
                  const Icon(Icons.account_circle_outlined, size: 28),
                ],
              ),
              const SizedBox(height: 24),

              const Text(
                'Make time for cross–training\nThese runner–approved workouts are here …',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              // List of workouts
              Expanded(
                child: Obx(() => ListView.builder(
                      itemCount: controller.stretchingList.length,
                      itemBuilder: (context, index) {
                        final item = controller.stretchingList[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  item['image']!,
                                  width: 100,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title']!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.brown,
                                    ),
                                  ),
                                  Text(
                                    '${item['level']} *',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.brown,
                                    ),
                                  ),
                                  Text(
                                    item['duration']!,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.brown,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    )),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          // nanti tambahkan navigasi antar halaman
        },
        selectedItemColor: const Color(0xFF52463B),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.accessibility_new), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }
}
