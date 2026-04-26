class Employee {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String job;
  final bool isFavorite;

  Employee({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.job,
    required this.isFavorite,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    final data = json["data"];
    return Employee(
      id: json["id"],
      name: data["name"],
      phone: data["phone"],
      email: data["email"],
      job: data["job"],
      isFavorite: data["is_favorite"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "data": {
        "name": name,
        "phone": phone,
        "email": email,
        "job": job,
        "is_favorite": isFavorite,
      }
    };
  }

  Employee copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? job,
    bool? isFavorite,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      job: job ?? this.job,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}