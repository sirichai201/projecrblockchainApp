

const bodyParser = require('body-parser');
const express = require('express');



const Web3 = require('web3').Web3; // สำหรับบางเวอร์ชั่นของ web3
const PRIVATE_KEY = "0x58e5143c330b8486078304a7521a7557ccad0baf39efb396350f42e02f67665d";
console.log(PRIVATE_KEY);



const app = express();


app.use(bodyParser.json());  // สำหรับ request ที่ส่งเป็น JSON
app.use(bodyParser.urlencoded({ extended: true }));  // สำหรับ form submissions
const port = 3000;
const INFURA_URL = 'http://127.0.0.1:7545';
const CONTRACT_ADDRESS = '0x05f889187f8C51DA898183feE7Fbd971BD69e711';
const contractABI = require('./contractABI.json');


  const web3 = new Web3(new Web3.providers.HttpProvider(INFURA_URL));
  const contract = new web3.eth.Contract(contractABI, CONTRACT_ADDRESS);
  const account = web3.eth.accounts.privateKeyToAccount(PRIVATE_KEY);
 
const handleErrors = (res, error) => {
    console.error(error);
    res.status(400).send(error.message);
}

app.post('/createUser', async (req, res) => {
  console.log(req.body);
  const { username, password, role } = req.body;

  // Fetch the chainId
  const chainId = await web3.eth.net.getId();

  // Check for the role
  if (role !== 'student' && role !== 'teacher' && role !== 'admin') {
      return res.status(400).send('Invalid role provided');
  }

  try {
    // Create transaction
    const tx = {
      from: account.address,
      to: CONTRACT_ADDRESS,
      data: contract.methods.createUser(username, password, role).encodeABI(),
      gas: 2000000,
      gasPrice: web3.utils.toWei('20', 'gwei'),
      chainId: chainId  // Add the chainId here
    };
    console.log(tx);
    const signedTx = await web3.eth.accounts.signTransaction(tx, PRIVATE_KEY);
    console.log(signedTx);
    const receipt = await web3.eth.sendSignedTransaction(signedTx.rawTransaction);
    console.log('Transaction completed:', receipt.transactionHash);
    
    const jsonString = JSON.stringify(receipt, (_, value) => typeof value === 'bigint' ? value.toString() : value);
    res.send(jsonString);
    

    
  } catch (error) {
      handleErrors(res, error);
  }
});




app.get('/getSecretKey', (req, res) => {
  res.json({ secretKey: process.env.SECRET_KEY });
});


app.get('/fetch/users', async (req, res) => {
  try {
      const users = await contract.methods.getAllUsers().call();
      res.json(users);
  } catch (error) {
      res.status(500).send(error.toString());
  }
});





// app.put('/changePassword', async (req, res) => {
//     const { username, newPassword } = req.body;
//     try {
//         const result = await contract.methods.changePassword(username, newPassword).send({ from: OWNER_ADDRESS, gas: GAS_LIMIT, gasPrice: GAS_PRICE });
//         res.send(result);
//     } catch (error) {
//         handleErrors(res, error);
//     }
// });

// app.post('/login', async (req, res) => {
//     const { username, password } = req.body;
//     try {
//         const role = await contract.methods.login(username, password).call();

//         // สร้าง token โดยใช้ username และ role เป็น payload
//         const token = jwt.sign({ username, role }, process.env.SECRET_KEY, { expiresIn: '1h' });

//         res.send({ token });
//     } catch (error) {
//         handleErrors(res, error);
//     }
// });

app.listen(port,'0.0.0.0',() =>{
console.log('Server started on http://localhost:3000');
});

