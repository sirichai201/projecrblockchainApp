import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_blockchain/gobal/drawerbar_nisit.dart';

import 'edit_profile_nisit.dart';

class ProfileNisitScreen extends StatefulWidget {
  @override
  _ProfileNisitScreenState createState() => _ProfileNisitScreenState();
}

class _ProfileNisitScreenState extends State<ProfileNisitScreen> {
  File? _profileImage;

  Map<String, dynamic> _nisitUserData = {
    'name': 'Sirichai',
    'lastName': 'chantharasri',
    'email': 'sirichai.c@ku.th',
    'studentId': '63402050682222',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile_nisit')),
      drawer: const DrawerBarNisit(),
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
                : const AssetImage('assets/images/Profile.png'),
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
            'ชื่อ: ${_nisitUserData['name']}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            'นามสกุล: ${_nisitUserData['lastName']}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            'Email: ${_nisitUserData['email']}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            'รหัสนิสิต: ${_nisitUserData['studentId']}',
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
        builder: (context) => EditProfileNisit(userData: _nisitUserData),
      ),
    );

    if (result is Map<String, dynamic>) {
      setState(() {
        _nisitUserData = result;

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
