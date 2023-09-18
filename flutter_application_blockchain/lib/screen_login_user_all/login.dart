// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import '../screen_addmin/user_admin.dart';
import '../screen_lecturer/User_lecturer.dart';
import '../screen_nisit/User_nisit.dart';
import 'forget_password.dart';
import 'dart:convert';
import "package:jwt_decoder/jwt_decoder.dart";

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // ตัวแปรสำหรับตรวจสอบว่ากำลังโหลดหรือไม่

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('เข้าสู่ระบบ')),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(30.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/ku.png',
                    width: 100,
                    height: 150,
                  ),
                  const SizedBox(height: 30.0),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  const SizedBox(height: 20.0),
                  _loginButton(context),
                  const SizedBox(height: 10.0),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgetPassword(),
                        ),
                      );
                    },
                    child: const Text('Forgot Password?'),
                  ),
                ],
              ),
            ),
          ),
          // แสดง spinner ขณะโหลด
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          _isLoading = true;
        });

        try {
          // 1. ตรวจสอบกับ Smart Contract ว่าเป็น admin หรือไม่
          final adminResponse = await http.post(
            Uri.parse('http://10.0.2.2:3000/authenticateAdmin'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode({
              'username': _usernameController.text,
              'password': _passwordController.text,
            }),
          );

          if (adminResponse.statusCode == 200 &&
              json.decode(adminResponse.body)['isAdmin'] == true) {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => UserAdmin()));
            return; // ออกจาก function หลังจากทำการ push แล้ว
          }

          // 2. ถ้าไม่ใช่ admin ดำเนินการเข้าสู่ระบบปกติ
          final response = await http.post(
            Uri.parse('http://10.0.2.2:3000/login'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode({
              'username': _usernameController.text,
              'password': _passwordController.text,
            }),
          );

          print('Server Response: ${response.body}');

          if (response.statusCode == 200) {
            final responseBody = json.decode(response.body);
            final token = responseBody['token'];
            final role = JwtDecoder.decode(token)['role'];

            if (role == 'teacher') {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => UserLecturer()));
            } else if (role == 'student') {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => UserNisit()));
            } else if (role == 'admin') {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserAdmin())); // สำหรับ admin
            } else {
              throw Exception('Unknown user role');
            }
          } else {
            throw Exception('Login failed');
          }
        } catch (e) {
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Error'),
              content: Text('An error occurred: ${e.toString()}'),
              actions: [
                TextButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            ),
          );
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      },
      child: Text('Login', style: TextStyle(fontSize: 18)),
    );
  }
}
