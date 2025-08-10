class Department {
  final int id;
  final String title;

  Department({required this.id, required this.title});

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'] ?? '',
    );
  }
}
