// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:web3dart/web3dart.dart';

import 'user_admin.dart';

// คลาสสำหรับการสร้างบัญชีผู้ใช้
class CreateUser extends StatefulWidget {
  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  late Credentials _credentials;

  late Web3Client _client;
  late DeployedContract _contract;
  late ContractFunction _createUserFunction;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _dropdownValue = 'student';

  final abiString = '''[
    {
      "inputs": [],
      "stateMutability": "nonpayable",
      "type": "constructor"
    },
    {
      "inputs": [],
      "name": "admin",
      "outputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "",
          "type": "string"
        }
      ],
      "name": "users",
      "outputs": [
        {
          "internalType": "string",
          "name": "username",
          "type": "string"
        },
        {
          "internalType": "string",
          "name": "password",
          "type": "string"
        },
        {
          "internalType": "string",
          "name": "role",
          "type": "string"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "_username",
          "type": "string"
        },
        {
          "internalType": "string",
          "name": "_password",
          "type": "string"
        }
      ],
      "name": "authenticateAdmin",
      "outputs": [
        {
          "internalType": "bool",
          "name": "",
          "type": "bool"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "_username",
          "type": "string"
        },
        {
          "internalType": "string",
          "name": "_password",
          "type": "string"
        },
        {
          "internalType": "string",
          "name": "_role",
          "type": "string"
        }
      ],
      "name": "createUser",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "_username",
          "type": "string"
        }
      ],
      "name": "getUser",
      "outputs": [
        {
          "components": [
            {
              "internalType": "string",
              "name": "username",
              "type": "string"
            },
            {
              "internalType": "string",
              "name": "password",
              "type": "string"
            },
            {
              "internalType": "string",
              "name": "role",
              "type": "string"
            }
          ],
          "internalType": "struct MyContractBlockchain.User",
          "name": "",
          "type": "tuple"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "_username",
          "type": "string"
        },
        {
          "internalType": "string",
          "name": "_password",
          "type": "string"
        }
      ],
      "name": "authenticate",
      "outputs": [
        {
          "internalType": "bool",
          "name": "",
          "type": "bool"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "_username",
          "type": "string"
        }
      ],
      "name": "checkUserRole",
      "outputs": [
        {
          "internalType": "string",
          "name": "",
          "type": "string"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    }
  ]
    
  ''';
  @override
  void initState() {
    super.initState();
    _initializeWeb3();
  }

  _initializeWeb3() async {
    // ตั้งค่า Web3Client ด้วย endpoint ของ Ethereum node
    _client = Web3Client("http://10.0.2.2:7545", http.Client());

    // กำหนดค่า _credentials ด้วย privateKey
    // ignore: deprecated_member_use
    _credentials = await _client.credentialsFromPrivateKey(
        "58e5143c330b8486078304a7521a7557ccad0baf39efb396350f42e02f67665d");

    if (_credentials == null) {
      _showDialog(context,
          'ท่านยังไม่ได้ทำการกำหนดค่า _credentials ซึ่งเป็นตัวรับ credentials สำหรับการทำ transaction บน blockchain');
      return;
    }

    // สร้าง DeployedContract object โดยอ่าน ABI และ address ของสมาร์ทคอนแทร็กต์
    _contract = DeployedContract(
      ContractAbi.fromJson(abiString, 'MyContractBlockchain'),
      EthereumAddress.fromHex('0x74c8F2f160Ad19C1B9F1b9D1a1d169c7CFe4Ab5A'),
    );

    // ดึง function ที่ต้องการจากสมาร์ทคอนแทร็กต์
    _createUserFunction = _contract.function('createUser');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สร้างบัญชี'),
        leading: IconButton(
          // ปุ่มย้อนกลับ
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        UserAdmin())); // ย้อนกลับไปหน้าก่อนหน้า
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            buildUsernameField(),
            const SizedBox(height: 16),
            buildPasswordField(),
            const SizedBox(height: 16),
            buildDropdown(),
            const SizedBox(height: 16),
            buildCreateButton(context),
          ],
        ),
      ),
    );
  }

  TextField buildUsernameField() {
    return TextField(
      controller: _usernameController,
      onChanged: (value) {
        final specialCharacterPattern = RegExp(r'[!@#\$&*~]');
        if (value.length < 5) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Username ต้องมีความยาวอย่างน้อย 5 ตัวอักษร')),
          );
        } else if (specialCharacterPattern.hasMatch(value)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Username ไม่ควรมีตัวอักษรพิเศษ')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Username โอเคแล้ว')),
          );
        }
      },
      decoration: const InputDecoration(
        labelText: 'Username',
      ),
    );
  }

  TextField buildPasswordField() {
    return TextField(
      controller: _passwordController,
      onChanged: (value) {
        if (value.length < 8) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Password ต้องมีความยาวอย่างน้อย 8 ตัวอักษร')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password โอเคแล้ว')),
          );
        }
      },
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Password',
      ),
    );
  }

  DropdownButton<String> buildDropdown() {
    return DropdownButton<String>(
      value: _dropdownValue,
      icon: const Icon(Icons.arrow_drop_down),
      onChanged: (String? newValue) {
        setState(() {
          _dropdownValue = newValue!;
        });
      },
      items: <String>['student', 'teacher']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  ElevatedButton buildCreateButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          String role = _dropdownValue; // Simplified

          final bodyData = {
            'username': _usernameController.text,
            'password': _passwordController.text,
            'role': role,
          };

          // Connect to your server
          final response = await http.post(
            Uri.parse('http://10.0.2.2:3000/createUser'),
            body: bodyData,
          );

          if (response.statusCode == 200) {
            _showDialog(context, 'สร้างบัญชีสำเร็จ');

            // Call Ethereum smart contract method after successful server response
            await _client.sendTransaction(
              _credentials,
              Transaction.callContract(
                contract: _contract,
                function: _createUserFunction,
                parameters: [
                  _usernameController.text,
                  _passwordController.text,
                  role
                ],
                // Ensure you have proper gas and value settings for the transaction
              ),
            );
          } else {
            // Handle error
            _showDialog(context, 'เกิดข้อผิดพลาด: ${response.body}');
          }
        } catch (e) {
          _showDialog(context, 'เกิดข้อผิดพลาด: $e');
        }
      },
      child: Text('สร้างบัญชี'),
    );
  }

  _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('สถานะการทำธุรกรรม'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('ปิด'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
