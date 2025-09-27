class UserModel {
  String id;
  String name;
  String displayName;

  UserModel({
    required this.id,
    required this.name,
    required this.displayName,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      displayName: json['displayName'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': name,
      'createdAt': displayName,
    };
  }
}
