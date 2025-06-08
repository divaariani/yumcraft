class UserModel {
  final String? id;
  final String? name;
  final String? imageUrl;
  final String? email;
  final String? password;

  UserModel({
    this.id,
    this.name,
    this.imageUrl,
    this.email,
    this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      imageUrl: json['image_url'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'email': email,
      'password': password,
    };
  }
}
