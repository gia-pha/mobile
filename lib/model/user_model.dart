class UserModel {
  String id;
  String name;
  String displayName;
  List<String> families;
  String currentFamilyId;

  UserModel({
    required this.id,
    required this.name,
    required this.displayName,
    required this.families,
    required this.currentFamilyId,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      displayName: json['displayName'],
      families: List<String>.from(json['families'] ?? []),
      currentFamilyId: json['currentFamilyId'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': name,
      'displayName': displayName,
      'families': families,
      'currentFamilyId': currentFamilyId,
    };
  }
}
