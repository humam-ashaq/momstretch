import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mom_stretch/app/data/app_colors.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
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
              title: Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 30, 24, 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.account_circle,
                      size: 30,
                      color: AppColors.primaryColor,
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
                    Icon(
                      Icons.notifications,
                      size: 30,
                      color: Color.fromARGB(1000, 87, 76, 64),
                    ),
                  ],  
                ),
              ),
            ),
          )
        ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting + Notification Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Halo Mom! Ingin Memperoleh\nTubuh Ideal?\nYuk Stretching!',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        // Explore Button
                        ElevatedButton(
                          onPressed: () {
                            Get.toNamed('/stretching');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF52463B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Explore Stretching',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Image.asset(
                      'assets/images/pilihprogram.png',
                      height: 120,
                    )
                  ],
                ),

                const SizedBox(height: 24),

                // Artikel Section
                articleCard(
                  image: 'assets/images/berita.png',
                  title:
                      'Bunda, Ini yang Terjadi pada Dirimu\nSesudah Melahirkan',
                ),
                const SizedBox(height: 16),
                articleCard(
                  image: 'assets/images/berita.png',
                  title: 'Bolehkah Ibu Tidur Siang Setelah\nMelahirkan?',
                ),
                const SizedBox(height: 16),
                articleCard(
                  image: 'assets/images/berita.png',
                  title: 'Tips Mengatur Pola Makan Pasca\nPersalinan',
                ),
                const SizedBox(height: 24),

                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/artikel'); // atau route artikel lainnya
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF52463B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'View All',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
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

  Widget articleCard({required String image, required String title}) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          child: ClipRRect(
            child: Image.asset(image),
          ),
        ),
        Positioned(
          bottom: 48,
          left: 48,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  shadows: [
                    Shadow(
                      blurRadius: 4.0,
                      color: Colors.black,
                      offset: Offset(1, 1),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed('/artikel-detail');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFCE9D3),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Read Now'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
