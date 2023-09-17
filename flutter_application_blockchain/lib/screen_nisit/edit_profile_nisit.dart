import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../gobal/drawerbar_nisit.dart';

class EditProfileNisit extends StatefulWidget {
  final Map<String, dynamic> userData;

  EditProfileNisit({required this.userData});

  @override
  _EditProfileNisitState createState() => _EditProfileNisitState();
}

class _EditProfileNisitState extends State<EditProfileNisit> {
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
      drawer: const DrawerBarNisit(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('แก้ไขข้อมูลบัญชี'),
      actions: [
        IconButton(
          icon: Icon(Icons.save),
          onPressed: _saveProfileChanges,
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfilePicture(),
          SizedBox(height: 20),
          _buildTextField('ชื่อ:', _nameController),
          SizedBox(height: 20),
          _buildTextField('นามสกุล:', _lastNameController),
          SizedBox(height: 20),
          _buildTextField('Email:', _emailController),
          SizedBox(height: 20),
          _buildTextField('รหัสนิสิต:', _studentIdController),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveProfileChanges,
            child: Text('บันทึก'),
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
                : AssetImage('assets/images/Profile.png'),
          ),
          Positioned(
            bottom: 140,
            right: 4,
            child: InkWell(
              onTap: _showChangeImageDialog,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.withOpacity(0.8),
                ),
                child: Icon(Icons.edit, color: Colors.white),
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
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        SizedBox(height: 8.0),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'กรุณากรอก$label',
            border: OutlineInputBorder(),
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
