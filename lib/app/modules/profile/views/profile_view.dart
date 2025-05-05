import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mom_stretch/app/data/app_colors.dart';
import '../controllers/profile_controller.dart';
import 'profile_edit_view.dart';

class ProfileView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            decoration: BoxDecoration(
              
              boxShadow: [
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
                      icon: Icon(Icons.arrow_back_ios, color: AppColors.primaryColor,),
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
                      icon: const Icon(Icons.edit, color: Colors.white,),
                      onPressed: () {
                        Get.to(() => ProfileEditView());
                      },
                    )
                  ],
                ),
              ),
            ),
          )
        ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: controller.fotoProfil.value.isNotEmpty
                    ? NetworkImage(controller.fotoProfil.value)
                    : const AssetImage('assets/images/default_profile.jpg')
                        as ImageProvider,
              ),
              Text(
                "Asih Rahmawati",
                style: TextStyle(
                  fontSize: 24,
                  color: AppColors.primaryColor
                ),
              ),
              Text(
                'asihra123@gmail.com',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.primaryColor
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.book, color: AppColors.primaryColor,),
                title: Text('Persalinan Normal', style: TextStyle(color: AppColors.primaryColor),),
                subtitle: const Text('Program Stretching', style: TextStyle(color: AppColors.primaryColor),),
              ),
              ListTile(
                leading: const Icon(Icons.cake, color: AppColors.primaryColor,),
                title: Text('26 Tahun', style: TextStyle(color: AppColors.primaryColor),),
                subtitle: const Text('Usia', style: TextStyle(color: AppColors.primaryColor),),
              ),
              const SizedBox(height: 16,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.forthColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      menuTile(Icons.edit, 'Ubah Profil', () {
                        Get.toNamed('/profile-edit');
                      }),
                      Divider(color: Colors.white),
                      menuTile(Icons.info_outline, 'Tentang Aplikasi', () {
                        Get.toNamed('/about');
                      }),
                      Divider(color: Colors.white),
                      menuTile(Icons.logout, 'Keluar', () {
                        controller.performLogout();
                      }),                      
                    ],
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

Widget menuTile(IconData icon, String title, VoidCallback onTap) {
  return ListTile(
    leading: Icon(icon, color: AppColors.primaryColor),
    title: Text(title, style: TextStyle(color: AppColors.primaryColor)),
    trailing: Icon(Icons.arrow_forward_ios, color: AppColors.primaryColor, size: 16),
    onTap: onTap,
  );
}
