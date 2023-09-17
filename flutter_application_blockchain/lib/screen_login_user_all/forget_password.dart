import 'package:flutter/material.dart';

class ForgetPassword extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();

  ForgetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ลืมรหัสผ่าน'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ลืมรหัสผ่าน',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'กรุณากรอกข้อมูลด้านล่างเพื่อกู้คืนรหัสผ่านของคุณ',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'อีเมล์'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _fullNameController,
              decoration: const InputDecoration(labelText: 'ชื่อ - นามสกุล'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _studentIdController,
              decoration: const InputDecoration(labelText: 'รหัสนิสิต'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Perform OTP verification logic here
                // You can access the entered values using the controller's text property
              },
              child: const Text('หน้าถัดไป'),
            ),
          ],
        ),
      ),
    );
  }
}
