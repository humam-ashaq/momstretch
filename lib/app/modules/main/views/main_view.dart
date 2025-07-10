import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/app_colors.dart';
import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
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
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                elevation: 0,
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 30, 8, 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.toNamed('/profile');
                        },
                        icon: Icon(
                          Icons.account_circle,
                          size: 30,
                          color: AppColors.primaryColor,
                        ),
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
                          onPressed: () {
                            Get.toNamed('/reminder');
                          },
                          icon: Icon(
                            Icons.notifications,
                            size: 30,
                            color: Colors.transparent,
                          )),
                    ],
                  ),
                ),
              ),
            )),
        body: controller.pages[controller.currentIndex.value],
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: BottomNavigationBar(
            backgroundColor: AppColors.forthColor,
            currentIndex: controller.currentIndex.value,
            onTap: controller.changePage,
            selectedItemColor: const Color(0xFF52463B),
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.accessibility_new),
                label: 'Stretching',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.monitor_heart_outlined),
                label: 'Cek Mood',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book),
                label: 'Edukasi',
              ),
            ],
          ),
        ),
      ),
    );
  }
}