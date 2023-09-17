import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_blockchain/gobal/drawerbar_lecturer.dart';

class HistoryLecturer extends StatefulWidget {
  final Map<String, String> subject;

  HistoryLecturer({required this.subject});

  @override
  _HistoryLecturerState createState() => _HistoryLecturerState();
}

class _HistoryLecturerState extends State<HistoryLecturer> {
  DateTime? selectedDate;
  String selectedDateText = "เลือกวันที่";

  // สร้าง List สำหรับเก็บรายชื่อวิชา
  List<String> subjectList = [
    'วิชา 1',
    'วิชา 2',
    'วิชา 3',
    'วิชา 11',
    'วิชา 21'
  ];

  // ตัวแปรสำหรับควบคุมการแสดงรายชื่อวิชาที่ค้นหา
  List<String> filteredSubjectList = [];

  // ตัวแปรสำหรับเก็บข้อมูลการค้นหา
  String searchText = '';
//ปุ่มกากออก
  TextEditingController searchController = TextEditingController();

  // ฟังก์ชันค้นหาวิชา
  void searchSubject(String query) {
    setState(() {
      filteredSubjectList = subjectList
          .where(
              (subject) => subject.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Widget _buildSearchBox() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        onChanged: (query) => searchSubject(query),
        decoration: InputDecoration(
          hintText: 'ค้นหาวิชา...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filteredSubjectList.length,
        itemBuilder: (context, index) {
          final subject = filteredSubjectList[index];
          return ListTile(
            title: Text(subject),
            // จัดการเมื่อกดที่รายชื่อวิชา
            onTap: () {
              // อาจจะเพิ่มโค้ดเมื่อผู้ใช้คลิกที่รายชื่อวิชา
            },
          );
        },
      ),
    );
  }

  Widget _buildDrawerItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      margin:
          const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
      decoration: BoxDecoration(
        border:
            Border.all(color: Colors.grey, width: 2), // กำหนดเส้นโครงของกรอบ
        borderRadius: BorderRadius.circular(
            10.0), // กำหนดขอบเส้นโครงเป็นรูปสี่เหลี่ยมเหลี่ยม
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ประวัติการเข้าเรียนของอาจารย์"),
      ),
      drawer: const DrawerbarLecturer(),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ปฎิทินและช่องกำหนดวันที่
                InkWell(
                  onTap: () => _selectDate(context),
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.calendar_today),
                          const SizedBox(width: 15),
                          Text(selectedDateText,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 100),

                _buildSearchBox(), // เพิ่ม Search Box
                const SizedBox(height: 20),
                _buildSubjectList(), // เพิ่มรายการวิชาที่ค้นหา

                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    thickness: 1, // ความหนาของเส้น Divider
                    color: Color.fromARGB(255, 22, 22, 22), // สีของเส้น Divider
                    height: 10, // ระยะห่างระหว่าง SizedBox กับ PieChartWidget
                  ),
                ),
                const SizedBox(height: 20),

                // กล่องรายชื่อคนที่มาเรียน ขาดเรียน และลา
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 120, // เพิ่มขนาดกว้างของกล่อง DropdownButton
                      child: _buildDropdownButton("มาเรียน", Colors.green),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 120, // เพิ่มขนาดกว้างของกล่อง DropdownButton
                      child: _buildDropdownButton("ขาดเรียน", Colors.red),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 120, // เพิ่มขนาดกว้างของกล่อง DropdownButton
                      child: _buildDropdownButton("ลา", Colors.yellow),
                    ),
                  ],
                ),

                const SizedBox(height: 50),
                // ส่วนแสดงรายชื่อนักเรียน (กราฟวงกลม)
                PieChartWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownButton(String title, Color color) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: title, // ให้ Dropdown แสดง title ในแต่ละกล่องเป็นค่า default
          onChanged: (newValue) {
            // ใส่โค้ดที่ต้องการเมื่อกด dropdown และเลือกค่าใหม่
            print('Selected: $newValue');
          },
          items: <String>[title].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    title == "มาเรียน"
                        ? Icons.check_circle // กำหนด Icon สำหรับมาเรียน
                        : title == "ขาดเรียน"
                            ? Icons.cancel // กำหนด Icon สำหรับขาดเรียน
                            : Icons.hourglass_empty, // กำหนด Icon สำหรับลา
                    color: const Color.fromARGB(255, 19, 18, 18),
                  ),
                  const SizedBox(width: 8), // ระยะห่างระหว่างไอคอนกับข้อความ
                  Text(value,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 17, 17, 17))),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ฟังก์ชันเลือกวันที่
  Future<void> _selectDate(BuildContext context) async {
    DateTime? currentDate = DateTime.now();
    DateTime? firstDate = currentDate.subtract(const Duration(days: 365));
    DateTime? lastDate = currentDate.add(const Duration(days: 365));

    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate != null && selectedDate != currentDate) {
      setState(() {
        selectedDateText =
            "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
      });
    }
  }
}

// Widget สำหรับแสดงกราฟวงกลม (อย่างง่าย)
class PieChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: 25,
              color: Colors.red,
              title: '25%',
              titleStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            PieChartSectionData(
              value: 35,
              color: Colors.green,
              title: '35%',
              titleStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            PieChartSectionData(
              value: 40,
              color: Colors.blue,
              title: '40%',
              titleStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
          sectionsSpace:
              0, // ระยะห่างระหว่าง Section (หากต้องการให้ติดกันให้ใส่ 0)
          centerSpaceRadius: 40, // รัศมีของส่วนภายในของกราฟวงกลม
          borderData: FlBorderData(show: false), // แสดงเส้นขอบรอบกราฟวงกลม
          // ระยะห่างระหว่าง Section (หากต้องการให้มีระยะห่างระหว่าง Section)
        ),
      ),
    );
  }
}
