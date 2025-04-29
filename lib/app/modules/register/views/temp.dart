// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'register_controller.dart';

// class RegisterView extends GetView<RegisterController> {
//   const RegisterView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final nameC = TextEditingController();
//     final emailC = TextEditingController();
//     final passC = TextEditingController();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Register'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             TextField(
//               controller: nameC,
//               decoration: const InputDecoration(
//                 labelText: "Nama"
//               ),
//             ),
//             TextField(
//               controller: emailC,
//               decoration: const InputDecoration(labelText: "Email"),
//             ),
//             TextField(
//               controller: passC,
//               obscureText: true,
//               decoration: const InputDecoration(labelText: "Password"),
//             ),
//             const SizedBox(height: 20),
//             Obx(() {
//               return controller.isLoading.value
//                   ? const CircularProgressIndicator()
//                   : ElevatedButton(
//                       onPressed: () {
//                         controller.register(
//                           emailC.text.trim(),
//                           passC.text.trim(),
//                           nameC.text.trim(),
//                         );
//                       },
//                       child: const Text('Register'),
//                     );
//             }),
//           ],
//         ),
//       ),
//     );
//   }
// }



// void register() {
//     final name = nameController.text;
//     final email = emailController.text;
//     final pass = passwordController.text;
//     final confirm = confirmPasswordController.text;

//     if (pass != confirm) {
//       Get.snackbar("Error", "Password tidak cocok");
//       return;
//     }

//     print("Registering user: $name, $email");
//     // Tambahkan logika daftar ke backend di sini
//   }