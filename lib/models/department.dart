class Department {
  final int id;
  final String title;

  Department({required this.id, required this.title});

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(id: json['id'], title: json['title']);
  }
}
