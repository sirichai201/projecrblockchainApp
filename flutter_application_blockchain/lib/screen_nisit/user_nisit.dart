import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_blockchain/gobal/drawerbar_nisit.dart';

import 'subject_detail_nisit.dart';

class UserNisit extends StatefulWidget {
  const UserNisit({
    super.key,
  });

  @override
  _UserNisitState createState() => _UserNisitState();
}

class _UserNisitState extends State<UserNisit> {
  List<Map<String, String>> subjects = [
    {'code': '01111', 'name': 'วิชาAAA', 'group': '2'},
    {'code': '222', 'name': 'วิชาที่BBB', 'group': '1'},
    {'code': '03333', 'name': 'วิชาที่CCC', 'group': '3'},
  ];

  String? joinedSubjectCode; // Variable to store the joined subject code

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

  void _showJoinClassDialog() {
    TextEditingController codeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Join a Class"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "You are currently signed in with email:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                "sirichai.c@ku.th", // Replace with the user's email
                style: TextStyle(color: Colors.blue),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: codeController,
                decoration:
                    const InputDecoration(labelText: "Enter Class Code"),
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text("Join Class"),
              onPressed: () {
                String classCode = codeController.text.trim();
                // Check if class code is valid and join the class if needed
                // Replace this with your logic to verify and join the class
                if (isValidClassCode(classCode)) {
                  setState(() {
                    joinedSubjectCode = classCode;
                  });
                  Navigator.of(context).pop();
                  _showJoinSuccessDialog(); // เรียกใช้ฟังก์ชันแสดงข้อความเมื่อสำเร็จ
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Invalid class code.'),
                  ));
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showJoinSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Join Class Successful"),
          content: const Text("You have successfully joined the class!"),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool isValidClassCode(String classCode) {
    // Replace with your logic to validate the class code
    // Return true if it's a valid class code, otherwise, return false
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("UserNisit"
            //widget.nameFull ?? 'Name'
            ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              if (joinedSubjectCode == null) {
                _showJoinClassDialog();
              } else {
                // Handle navigation or display message for already joined class
                // For example, navigate to the subject detail screen for the joined subject
                // Or show a message that the user is already in a class
              }
            },
          ),
        ],
      ),
      drawer: DrawerBarNisit(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
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
                        builder: (context) => SubjectDetailNisit(
                          subject: subject,
                        ),
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
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(60.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ' ${index + 1}',
                              style: const TextStyle(
                                color: Colors.green,
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
                      const SizedBox(height: 20),
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
