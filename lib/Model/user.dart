class User {
  final String username;
  final String password;
  final String? email; // Add optional email field

  User({required this.username, required this.password, this.email});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      if (email != null) 'email': email, // Include email if it's not null
    };
  }
}
