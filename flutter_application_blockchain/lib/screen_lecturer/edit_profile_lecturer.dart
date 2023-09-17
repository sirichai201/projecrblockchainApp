import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_blockchain/gobal/drawerbar_lecturer.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class EditProfileLecturer extends StatefulWidget {
  final Map<String, dynamic> userData;

  EditProfileLecturer({required this.userData});

  @override
  _EditProfileLecturerState createState() => _EditProfileLecturerState();
}

class _EditProfileLecturerState extends State<EditProfileLecturer> {
  late TextEditingController _nameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _studentIdController;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.userData['name']);
    _lastNameController =
        TextEditingController(text: widget.userData['lastName']);
    _emailController = TextEditingController(text: widget.userData['email']);
    _studentIdController =
        TextEditingController(text: widget.userData['studentId']);
  }

  Future<void> _showChangeImageDialog() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _saveImageToAppDirectory(pickedFile);
    }
  }

  Future<void> _saveImageToAppDirectory(PickedFile pickedFile) async {
    File image = File(pickedFile.path);
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String path = appDocDir.path;
    _selectedImage = await image.copy('$path/selectedImage.png');
    print(_selectedImage);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: const DrawerbarLecturer(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('แก้ไขข้อมูลบัญชี'),
      actions: [
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: _saveProfileChanges,
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfilePicture(),
          const SizedBox(height: 20),
          _buildTextField('ชื่อ:', _nameController),
          const SizedBox(height: 20),
          _buildTextField('นามสกุล:', _lastNameController),
          const SizedBox(height: 20),
          _buildTextField('Email:', _emailController),
          const SizedBox(height: 20),
          _buildTextField('รหัสนิสิต:', _studentIdController),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveProfileChanges,
            child: const Text('บันทึก'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 100,
            backgroundImage: _selectedImage != null
                ? Image.file(_selectedImage!).image
                : const AssetImage('assets/images/Profile.png'),
          ),
          Positioned(
            bottom: 140,
            right: 4,
            child: InkWell(
              onTap: _showChangeImageDialog,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.withOpacity(0.8),
                ),
                child: const Icon(Icons.edit, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8.0),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'กรุณากรอก$label',
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  void _saveProfileChanges() {
    // ส่งข้อมูลที่ถูกแก้ไขกลับไปยังหน้า Profile_nisit.dart
    Navigator.pop(context, {
      'name': _nameController.text,
      'lastName': _lastNameController.text,
      'email': _emailController.text,
      'studentId': _studentIdController.text,
      'selectedImage': _selectedImage // ส่งไฟล์รูปภาพกลับ
    });
  }
}
