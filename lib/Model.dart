class User {
  final int userId;
  final String name;
  final String address;

  User({
    required this.userId,
    required this.name,
    required this.address,
  });
  const User.empty({
    this.userId = 0,
    this.name = '',
    this.address = '',
  });
  // Adjusted to handle different key names from the API response
  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json['userid'], // Match 'userid' from API response
        name: json['name'],
        address: json['address'],
      );

  Map<String, dynamic> toJson() => {
        "userid": userId, // Use 'userid' to align with the API
        "name": name,
        "address": address,
      };
}
