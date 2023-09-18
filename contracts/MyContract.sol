// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract MyContractBlockchain {
    struct User {
        string username;
        string password;
        string role; // "student" or "teacher"
    }
    
    mapping(string => User) public users;
      User[] public userList; // <-- เพิ่ม array สำหรับเก็บรายชื่อผู้ใช้

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
        _;
    }
    
    function authenticateAdmin(string memory _username, string memory _password) public view returns(bool) {
    return keccak256(abi.encodePacked(_username)) == keccak256(abi.encodePacked(adminUsername)) && keccak256(abi.encodePacked(_password)) == keccak256(abi.encodePacked(adminPassword));
}

    
    function createUser(string memory _username, string memory _password, string memory _role) public onlyAdmin {
        require(bytes(users[_username].username).length == 0, "Username already exists");
        require(keccak256(abi.encodePacked(_role)) == keccak256(abi.encodePacked("student")) || keccak256(abi.encodePacked(_role)) == keccak256(abi.encodePacked("teacher")), "Invalid role");
        users[_username] = User(_username, _password, _role);
        userList.push(User(_username, _password, _role)); // <-- เพิ่ม user ใหม่ลงใน array userList  
    }
  function getAllUsers() public view returns(User[] memory) {
    return userList;
}





    function authenticate(string memory _username, string memory _password) public view returns(bool) {
    return keccak256(abi.encodePacked(_password)) == keccak256(abi.encodePacked(users[_username].password));
}
    function checkUserRole(string memory _username) public view returns(string memory) {
    return users[_username].role;
}

}

