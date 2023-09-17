import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_blockchain/screen_lecturer/edit_profile_lecturer.dart';

import '../gobal/drawerbar_lecturer.dart';

class ProfileLecturer extends StatefulWidget {
  @override
  _ProfileLecturerState createState() => _ProfileLecturerState();
}

class _ProfileLecturerState extends State<ProfileLecturer> {
  File? _profileImage;

  Map<String, dynamic> _lecturerUserData = {
    'name': '5555',
    'lastName': '4444',
    'email': '55551',
    'studentId': '611212',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile_lecturer')),
      drawer: const DrawerbarLecturer(),
      body: _buildProfileBody(),
    );
  }

  Widget _buildProfileBody() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 25),
          CircleAvatar(
            radius: 100,
            backgroundImage: _profileImage != null
                ? Image.file(_profileImage!).image
                : AssetImage('assets/images/Profile.png'),
          ),
          const SizedBox(height: 25),
          const Align(
            alignment: Alignment.centerLeft,
            child: FractionalTranslation(
              translation: Offset(0.2, 0.0),
              child: Text(
                'ข้อมูลบัญชี',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildProfileDetails(),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetails() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 15),
          Text(
            'ชื่อ: ${_lecturerUserData['name']}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            'นามสกุล: ${_lecturerUserData['lastName']}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            'Email: ${_lecturerUserData['email']}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            'รหัสนิสิต: ${_lecturerUserData['studentId']}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: _navigateToEditProfile,
            child: const Text('แก้ไขข้อมูล'),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Future<void> _navigateToEditProfile() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileLecturer(userData: _lecturerUserData),
      ),
    );

    if (result is Map<String, dynamic>) {
      setState(() {
        _lecturerUserData = result;

        // ตรวจสอบว่ามี key 'selectedImage' ใน result หรือไม่
        if (result.containsKey('selectedImage')) {
          _profileImage = result['selectedImage'];
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('แก้ไขข้อมูลสำเร็จ')),
      );
    }
  }
}
