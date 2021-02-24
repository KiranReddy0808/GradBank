class User {
  String name;
  String phoneNum;
  String upiPin;

  User(this.name, this.phoneNum, this.upiPin);

  static List<User> getDummyUsers() {
    List<User> dummyUsers = [];
    dummyUsers.add(User('Shubham Shah', '0000000001', '000000'));
    dummyUsers.add(User('Ben Watson', '0000000002', '000000'));
    dummyUsers.add(User('Padma Tashi', '0000000003', '000000'));
    dummyUsers.add(User('Saikiran Reddy', '0000000004', '000000'));
    dummyUsers.add(User('Chandan T', '0000000005', '000000'));
    dummyUsers.add(User('Jacky Li', '0000000006', '000000'));
    return dummyUsers;
  }
}
