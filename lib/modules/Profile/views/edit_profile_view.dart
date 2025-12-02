import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class EditProfileView extends GetView<ProfileController> {
  EditProfileView({super.key});

  final TextEditingController nameC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameC.text = controller.username.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profil"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameC,
              decoration: InputDecoration(
                labelText: "Nama Baru",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.updateUsername(nameC.text.trim());
                  Get.back();
                },
                child: const Text("Simpan Perubahan"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
