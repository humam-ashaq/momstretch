import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import 'profile_edit_view.dart';

class ProfileView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.fromLTRB(12, 30, 12, 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
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
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Get.to(() => ProfileEditView());
                      },
                    )
                  ],
                ),
              ),
            ),
          )),
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
              const SizedBox(height: 8,),
              Text(
                "Asih",
                style: TextStyle(
                  fontSize: 32
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(controller.nama.value),
                subtitle: const Text('Nama'),
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: Text(controller.email.value),
                subtitle: const Text('Email'),
              ),
              ListTile(
                leading: const Icon(Icons.cake),
                title: Text(controller.usia.value),
                subtitle: const Text('Usia'),
              ),
            ],
          ),
        );
      }),
    );
  }
}
