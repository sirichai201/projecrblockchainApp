import 'package:flutter/material.dart';
import 'package:flutter_application_blockchain/gobal/drawerbar_nisit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SubjectDetailNisit extends StatefulWidget {
  final Map<String, String> subject;

  const SubjectDetailNisit({super.key, required this.subject});

  @override
  _SubjectDetailNisitState createState() => _SubjectDetailNisitState();
}

class User {
  final String name;

  User({required this.name});
}

// Define the Subject class
class Subject {
  final String name;
  final String code;

  Subject({required this.name, required this.code});
}

class _SubjectDetailNisitState extends State<SubjectDetailNisit> {
  String locationName = 'มหาวิทยาลัยเกษตรศาสตร์ สกลนคร';

  double latitude = 13.7563;
  double longitude = 100.5018;

  String userName = '';
  String subjectName = '';
  String subjectCode = '';
  String checkInDate = ''; // เพิ่มตัวแปรเก็บวันที่เช็คชื่อ

  Future<void> _clearCheckInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('checkedIn_${widget.subject['code']}');
    await prefs.remove('lastCheckInDateTime_${widget.subject['code']}');
    await prefs.remove('checkInDate_${widget.subject['code']}');
  }

  Future<void> _showDatePicker() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023), // กำหนดวันแรกที่สามารถเลือกได้
      lastDate: DateTime(2030), // กำหนดวันสุดท้ายที่สามารถเลือกได้
    );

    if (selectedDate != null) {
      // ตรวจสอบว่าผู้ใช้เลือกวันที่หรือยกเลิก
      _clearCheckInStatus(); // ล้างสถานะการเช็คอินก่อนเก็บวันที่ใหม่
      _setCheckInDate(selectedDate); // เรียกฟังก์ชันเพื่อเก็บวันที่เช็คชื่อ
      setState(() {
        // อัปเดต UI ด้วยการเรียก setState
        checkInDate = selectedDate.toString();
      });
    }
  }

// สร้างฟังก์ชันเพื่อบันทึกวันที่เช็คชื่อล่าสุด
  Future<void> _saveCheckInDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final currentDate = DateTime.now();
    final formattedDate = currentDate.toString(); // รับวันที่และเวลาปัจจุบัน

    await prefs.setString(
        'checkInDate_${widget.subject['code']}', formattedDate);
  }

// ฟังก์ชันสำหรับเก็บวันที่เช็คชื่อ
  Future<void> _setCheckInDate(DateTime selectedDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final formattedDate = selectedDate.toString(); // รับวันที่ที่ผู้ใช้เลือก

    await prefs.setString(
        'checkInDate_${widget.subject['code']}', formattedDate);
    // บันทึกวันที่ที่ผู้ใช้เลือกใน SharedPreferences
  }

  @override
  void initState() {
    super.initState();
    final user = User(name: 'ชื่อของผู้ใช้');
    userName = user.name;
    subjectName = widget.subject['name'] ?? 'รายละเอียดรายวิชา';
    subjectCode = widget.subject['code'] ?? '';

    _checkAndShowCheckInStatus();
  }

  // เพิ่มฟังก์ชันเพื่ออัปเดตชื่อตำแหน่งเมื่อมีการเปลี่ยนแปลง:
  void updateLocationName(String newName) {
    setState(() {
      locationName = newName;
    });
  }

  // ฟังก์ชันสร้าง Google Map
  Widget _buildGoogleMap() {
    return Column(
      children: [
        Container(
          height: 300, // กำหนดความสูงของแผนที่
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(latitude, longitude), // ตำแหน่งเริ่มต้นของแผนที่
              zoom: 15, // ระดับการซูมเริ่มต้น
            ),
            markers: {
              Marker(
                markerId: const MarkerId('selected_location'),
                position: LatLng(latitude, longitude),
              ),
            },
          ),
        ),
        const SizedBox(height: 10), // ระยะห่างระหว่างแผนที่กับข้อมูลด้านล่าง
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('ละติจูด: $latitude'),
                  const SizedBox(width: 20), // ระยะห่างระหว่าง Text
                  Text('ลองจิจูด: $longitude'),
                ],
              ),
              const SizedBox(height: 10), // ระยะห่างระหว่างข้อมูลและกรอบ
              Container(
                padding: const EdgeInsets.all(8.0), // ระยะห่างรอบข้อความในกรอบ
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black), // สีขอบของกรอบ
                  borderRadius:
                      BorderRadius.circular(8.0), // กำหนดรูปแบบขอบกรอบ
                ),
                child: Text(
                  locationName, // ใช้ชื่อตำแหน่งที่เรากำหนด
                  style: const TextStyle(
                    fontSize: 16.0, // ขนาดตัวอักษร
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showCheckInRequestDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('คุณต้องการ Check-In หรือไม่?'),
          content:
              const Text('การ Check-In จะทำให้คุณได้รับรางวัล KU COIN +0.5'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performCheckIn();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              child: const Text('Check-In'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
              child: const Text('ยกเลิก'),
            ),
          ],
        );
      },
    );
  }

// ฟังก์ชันสำหรับบันทึกวันที่เช็คชื่อล่าสุด:
  // ฟังก์ชันสำหรับบันทึกวันที่และเวลาเมื่อมีการ Check-In
  Future<void> _saveLastCheckInDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final currentDate = DateTime.now();
    final formattedDate = currentDate.toString(); // รับวันที่และเวลาปัจจุบัน

    await prefs.setString(
        'lastCheckInDateTime_${widget.subject['code']}', formattedDate);
  }

  void _performCheckIn() async {
    // นี่คือส่วนของการดำเนินการ Check-In ของคุณ
    // คุณสามารถเพิ่มโค้ดเพื่อบันทึกสถานะ Check-In หรือดำเนินการอื่น ๆ ตามต้องการ

    _saveCheckInStatus(); // บันทึกสถานะ Check-In
    _saveLastCheckInDate(); // บันทึกวันที่เช็คชื่อล่าสุด

    // เพิ่มบรรทัดนี้เพื่อบันทึกวันที่เช็คชื่อล่าสุด
    _saveCheckInDate();

    // แสดง Dialog การยืนยัน Check-In
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('คุณได้ Check-In แล้ว'),
          content: const Text('คุณได้รับรางวัล KU COIN +0.5'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิดหน้าต่างเช็คอิน
                _checkAndShowCheckInStatus(); // แสดงสถานะการเช็คอิน
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              child: const Text('ตกลง'),
            ),
          ],
        );
      },
    );
  }

  void _showAlreadyCheckedInDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('เช็คอินแล้ว!'),
          content: const Text('คุณได้ทำการเช็คอินในวันนี้ไปแล้ว.'),
          actions: [
            TextButton(
              child: const Text('ตกลง'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showCheckInDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.green,
          title: const Text('คุณต้องการยืนยันการรับเหรียญ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ชื่อ: $userName',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'วิชา: $subjectName ($subjectCode)',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.green,
                ),
                child: const Text(
                  'KU COIN +0.5',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิด AlertDialog นี้
                _showCheckInRequestDialog(); // เรียกตรวจสอบและแสดงสถานะการ Check In อีกครั้ง
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              child: const Text('ยืนยัน'),
            ),
          ],
        );
      },
    );
  }

  //สร้างฟังก์ชันเพื่อบันทึกสถานะ Check In:
  Future<void> _saveCheckInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('checkedIn_${widget.subject['code']}',
        true); // บันทึกสถานะ Check-In เป็น true
  }

  //สร้างฟังก์ชันเพื่อตรวจสอบสถานะการ Check In และแสดงข้อความ:
  //ใน _checkAndShowCheckInStatus() เพิ่มเงื่อนไขเพื่อตรวจสอบว่าได้ Check-In ในวันเดียวกันหรือไม่:
  // ฟังก์ชันเพื่อตรวจสอบสถานะการ Check-In และแสดงข้อความ:
  // แก้ไขและเพิ่มเงื่อนไขตรวจสอบสถานะ Check-In ใน _checkAndShowCheckInStatus
  Future<void> _checkAndShowCheckInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // แสดงค่าเพื่อ debug
    print("Checking for subject code: ${widget.subject['code']}");
    bool checkedIn =
        prefs.getBool('checkedIn_${widget.subject['code']}') ?? false;

    String lastCheckInDateTimeStr =
        prefs.getString('lastCheckInDateTime_${widget.subject['code']}') ??
            'ยังไม่เคย Check-In';

    DateTime? lastCheckInDateTime;
    if (lastCheckInDateTimeStr != 'ยังไม่เคย Check-In') {
      try {
        lastCheckInDateTime = DateTime.parse(lastCheckInDateTimeStr);
      } catch (e) {
        print("Error parsing last check-in date: $e");
      }
    }

    String checkInDateStr =
        prefs.getString('checkInDate_${widget.subject['code']}') ??
            'ยังไม่ได้กำหนดวันที่เช็คชื่อ';
    DateTime? selectedCheckInDate;
    if (checkInDateStr != 'ยังไม่ได้กำหนดวันที่เช็คชื่อ') {
      try {
        selectedCheckInDate = DateTime.parse(checkInDateStr);
      } catch (e) {
        print("Error parsing selected check-in date: $e");
      }
    }

    setState(() {
      this.checkInDate = checkInDateStr;
    });

    if (checkedIn &&
        lastCheckInDateTime != null &&
        selectedCheckInDate != null &&
        lastCheckInDateTime.day == selectedCheckInDate.day &&
        lastCheckInDateTime.month == selectedCheckInDate.month &&
        lastCheckInDateTime.year == selectedCheckInDate.year) {
      // ถ้าเช็คอินแล้วในวันที่เดียวกันกับที่เลือก
      _showAlreadyCheckedInDialog(); // แสดง Dialog ที่บอกว่า "เช็คอินไปแล้ว"
    } else {
      _showCheckInDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$subjectName ($subjectCode)',
        ),
      ),
      drawer: const DrawerBarNisit(),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildGoogleMap(),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    thickness: 1,
                    color: Color.fromARGB(255, 22, 22, 22),
                    height: 10,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      _checkAndShowCheckInStatus();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                    child: const Text('Check In'),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _showDatePicker();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                  ),
                  child: const Text('กำหนดวันที่เช็คชื่อ'),
                ),
                const SizedBox(height: 20),
                Text(
                  'วันที่เช็คชื่อล่าสุด: $checkInDate',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
