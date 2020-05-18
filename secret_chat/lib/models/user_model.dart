class User {
  final String id;
  final String username;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({this.id, this.username, this.email, this.createdAt, this.updatedAt});

  factory User.fromJson(Map<String, dynamic> json) {
    final createdAt = DateTime.parse(json['createdAt']);
    final updatedAt = DateTime.parse(json['updatedAt']);

    return User(
        id: json['_id'],
        username: json['username'],
        email: json['email'],
        createdAt: createdAt,
        updatedAt: updatedAt);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "username": this.username,
      "email": this.email,
      "createdAt": createdAt.toString(),
      "updatedAt": updatedAt.toString()
    };
  }
}
