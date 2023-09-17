import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_blockchain/gobal/drawerbar_lecturer.dart';

import 'subject_detail_lecturer.dart';

class UserLecturer extends StatefulWidget {
  @override
  _UserLecturerState createState() => _UserLecturerState();
}

class _UserLecturerState extends State<UserLecturer> {
  List<Map<String, String>> subjects = [
    {'code': '000011111', 'name': 'วิชาAAA', 'group': '2'},
    {'code': '000011111', 'name': 'วิชาที่BBB', 'group': '1'},
    {'code': '000011111', 'name': 'วิชาที่CCC', 'group': '3'},
  ];

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context, int index) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("ยืนยันการลบ"),
          content: const Text("คุณต้องการลบรายวิชานี้ใช่หรือไม่?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("ยกเลิก"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("ลบ"),
            ),
          ],
        );
      },
    );
  }

  void _addSubject() {
    TextEditingController codeController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController groupController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("เพิ่มรายการวิชาใหม่"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: codeController,
                decoration: const InputDecoration(labelText: "รหัสวิชา"),
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[ก-๙a-zA-Z0-9]')),
                ],
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "ชื่อรายวิชา"),
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[ก-๙a-zA-Z0-9]')),
                ],
              ),
              TextField(
                controller: groupController,
                decoration: const InputDecoration(labelText: "หมู่เรียน"),
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[ก-๙a-zA-Z0-9]')),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("ยกเลิก"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("เพิ่ม"),
              onPressed: () {
                String newCode = codeController.text.trim();
                String newName = nameController.text.trim();
                String newGroup = groupController.text.trim();

                if (newCode.isNotEmpty &&
                    newName.isNotEmpty &&
                    newGroup.isNotEmpty &&
                    !_subjectExists(newCode, newGroup)) {
                  setState(() {
                    subjects.add(
                        {'code': newCode, 'name': newName, 'group': newGroup});
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        'กรุณากรอกรหัสวิชาและหมู่เรียนที่ไม่ซ้ำกันและไม่เป็นค่าว่าง'),
                  ));
                }
              },
            ),
          ],
        );
      },
    );
  }

  bool _subjectExists(String code, String group) {
    return subjects
        .any((subject) => subject['code'] == code && subject['group'] == group);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User_lecturer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _addSubject(); // สร้างฟังก์ชัน _addSubject() ที่จะถูกเรียกเมื่อกดปุ่ม
            },
          ),
        ],
      ),
      drawer: const DrawerbarLecturer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80), // ระยะห่างระหว่างข้อความและรายวิชา
          Expanded(
            child: ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubjectDetail(subject: subject),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        margin: const EdgeInsets.only(
                            top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[300], // สีเทาสำหรับกรอบรายวิชา
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ' ${index + 1}',
                              style: const TextStyle(
                                color:
                                    Colors.green, // สีเขียวสำหรับเลขลำดับวิชา
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 60.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'รหัสวิชา: ${subject['code']}',
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  Text(
                                    'ชื่อรายวิชา: ${subject['name']}',
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  Text(
                                    'หมู่เรียน: ${subject['group']}',
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                bool? shouldDelete =
                                    await _showDeleteConfirmationDialog(
                                        context, index);
                                if (shouldDelete == true) {
                                  setState(() {
                                    subjects.removeAt(index);
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                          height: 20), // ระยะห่างระหว่างกรอบรายวิชาแต่ละรายการ
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
