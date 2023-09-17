// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract MyContractBlockchain {
    struct User {
        string username;    // username เข้าระบบ 
        string password;  // รหัสผ่านสำหรับผู้ใช้
        string role; // "student" or "teacher"
    }
    
    mapping(string => User) public users;
    address public admin;
    string private adminUsername;
    string private adminPassword;
    
      constructor() {
        admin = msg.sender;
        adminUsername = "Test00";
        adminPassword = "Test00";
    }
    
    modifier onlyAdmin() {
     require(msg.sender == admin, "Only admin can perform this action");
     _;// This line is important!

    }
    
   function authenticateAdmin(string memory _username, string memory _password) public view returns(bool) {
        return keccak256(abi.encodePacked(_username)) == keccak256(abi.encodePacked(adminUsername)) && keccak256(abi.encodePacked(_password)) == keccak256(abi.encodePacked(adminPassword));
    }
    function createUser(string memory _username, string memory _password, string memory _role) public onlyAdmin {
    require(bytes(users[_username].username).length == 0, "Username already exists");
    require(keccak256(abi.encodePacked(_role)) == keccak256(abi.encodePacked("student")) || keccak256(abi.encodePacked(_role)) == keccak256(abi.encodePacked("teacher")), "Invalid role");
    users[_username] = User(_username, _password, _role);
}

    
    function getUser(string memory _username) public view returns(User memory) {
    return users[_username];
}


    function authenticate(string memory _username, string memory _password) public view returns(bool) {
    return keccak256(abi.encodePacked(_password)) == keccak256(abi.encodePacked(users[_username].password));
}
    function checkUserRole(string memory _username) public view returns(string memory) {
    return users[_username].role;
}

}

