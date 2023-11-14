import 'dart:convert';

class UserModel {
  final String userId;
  final String name;
  final String imageUrl;
  UserModel({
    required this.userId,
    required this.name,
    required this.imageUrl,
  });

  UserModel copyWith({
    String? userId,
    String? name,
    String? imageUrl,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'userId': userId});
    result.addAll({'name': name});
    result.addAll({'imageUrl': imageUrl});

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'UserModel(userId: $userId, name: $name, imageUrl: $imageUrl)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.userId == userId &&
        other.name == name &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode => userId.hashCode ^ name.hashCode ^ imageUrl.hashCode;
}
