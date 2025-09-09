class User {
  final String fname;
  final String lname;
  final String email;
  final String phone;
  final String department;

  User({
    required this.fname,
    required this.lname,
    required this.email,
    required this.phone,
    required this.department,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fname: json['fname'] ?? '',
      lname: json['lname'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      department: json['department'] ?? '',
    );
  }
}
