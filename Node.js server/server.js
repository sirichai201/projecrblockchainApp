require('dotenv').config();

const express = require('express');
const Web3 = require('web3').Web3; // สำหรับบางเวอร์ชั่นของ web3
const bodyParser = require('body-parser');
const jwt = require('jsonwebtoken'); // เพิ่มการใช้ jsonwebtoken

const app = express();
app.use(bodyParser.json());
const web3 = new Web3('http://192.168.1.3:7545');
const contractABI =[
  {
    "inputs": [],
    "stateMutability": "nonpayable",
    "type": "constructor"
  },
  // {
  //   "username": "exampleUser",
  //   "password": "examplePass",
  //   "role": "student"
  // },
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
]; // เพิ่ม array ของ ABI ที่นี่
  const contract = new web3.eth.Contract(contractABI, "0x4bCDFc2EbC91D05A6e4B0Cb4d3131650D2fE27e5");
  const OWNER_ADDRESS = '0x2F397d0d71E51e1B90a05d1e14585814e03cE8A6';
  const GAS_LIMIT = 5000000; // 5,000,000 gas
  // ค่านี้เป็นแค่ตัวอย่าง, คุณต้องปรับค่านี้ตามความต้องการ
  const GAS_PRICE = '20000000000'; // 20 gwei, ตรงกับข้อมูลที่คุณให้มา
  
// ... (contractABI และค่าตัวแปรอื่น ๆ ยังคงเดิม)

app.use(express.json());

const handleErrors = (res, error) => {
    console.error(error);
    res.status(400).send(error.message);
}

app.post('/createUser', async (req, res) => {
  // รับข้อมูลที่ส่งมาจาก client
  const { username, password, role } = req.body;
  console.log('Received data:', req.body); //ดูค่าที่ส่งมายัง body 

  // ตรวจสอบว่า role มีค่าที่ถูกต้องหรือไม่
  if (role !== 'student' && role !== 'teacher' && role !== 'admin') {
      return res.status(400).send('Invalid role provided');
  }

  try {
      // เรียกใช้ function createUser ใน smart contract
      const result = await contract.methods.createUser(username, password, role).send({
          from: OWNER_ADDRESS,
          gas: GAS_LIMIT,
          gasPrice: GAS_PRICE
      });
      
      // แปลง result เป็น string ก่อนที่จะส่งผ่าน res.send
      res.send(JSON.parse(JSON.stringify(result)));
  } catch (error) {
      // การจัดการกับข้อผิดพลาด
      handleErrors(res, error);
  }
});


app.put('/changePassword', async (req, res) => {
    const { username, newPassword } = req.body;
    try {
        const result = await contract.methods.changePassword(username, newPassword).send({ from: OWNER_ADDRESS, gas: GAS_LIMIT, gasPrice: GAS_PRICE });
        res.send(result);
    } catch (error) {
        handleErrors(res, error);
    }
});

app.post('/login', async (req, res) => {
    const { username, password } = req.body;
    try {
        const role = await contract.methods.login(username, password).call();

        // สร้าง token โดยใช้ username และ role เป็น payload
        const token = jwt.sign({ username, role }, process.env.SECRET_KEY, { expiresIn: '1h' });

        res.send({ token });
    } catch (error) {
        handleErrors(res, error);
    }
});

app.listen(3000, () => {
    console.log('Server started on http://localhost:3000');
});
