class User {
  String username, email, avatarUrl, firstName, lastName;
  bool isOwner;
  User(
      {this.username,
      this.email,
      this.avatarUrl,
      this.firstName,
      this.lastName,
      this.isOwner});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        username: json['username'],
        email: json['email'],
        avatarUrl: json['photo_url'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        isOwner: json['is_owner']);
  }
}
