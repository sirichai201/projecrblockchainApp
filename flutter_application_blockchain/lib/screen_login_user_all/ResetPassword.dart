import 'package:flutter/material.dart';

import 'login.dart';

class ResetPasswordScreen extends StatefulWidget {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final String email;
  final String fullName;
  final String studentID;

  ResetPasswordScreen({
    Key? key,
    required this.email,
    required this.fullName,
    required this.studentID,
  }) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _passwordsMatch = true;

  @override
  void dispose() {
    widget._passwordController.dispose();
    widget._confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รีเซ็ตรหัสผ่าน'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              'อีเมล:',
              style: TextStyle(fontSize: 16),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                widget.email,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'ชื่อ-นามสกุล:',
              style: TextStyle(fontSize: 16),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                widget.fullName,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'รหัสนิสิต:',
              style: TextStyle(fontSize: 16),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                widget.studentID,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'กรอกรหัสผ่านใหม่',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            TextField(
              controller: widget._passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'รหัสผ่านใหม่'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: widget._confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'ยืนยันรหัสผ่านใหม่'),
              onChanged: (value) {
                setState(() {
                  _passwordsMatch = widget._passwordController.text == value;
                });
              },
            ),
            Visibility(
              visible: !_passwordsMatch,
              child: Text(
                'รหัสผ่านไม่ตรงกัน',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String password = widget._passwordController.text;
                String confirmPassword = widget._confirmPasswordController.text;
                if (password.isNotEmpty && password == confirmPassword) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('เปลี่ยนรหัสผ่านสำเร็จ'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()),
                              );
                            },
                            child: Text('ตกลง'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('ยืนยัน'),
            ),
          ],
        ),
      ),
    );
  }
}
