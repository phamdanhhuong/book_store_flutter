class User {
  final int id;
  final String username;
  final String fullname;
  final String email;
  final String phoneNumber;
  final String avatarUrl;

  User({
    required this.id,
    required this.username,
    required this.fullname,
    required this.email,
    required this.phoneNumber,
    required this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      fullname: json['fullname'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      avatarUrl: json['avatar_url'],
    );
  }
}
