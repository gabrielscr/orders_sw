import 'package:orders_sw/src/features/auth/domain/entities/user_auth.dart';

class UserAuthResponseModel extends UserAuthEntity {
  const UserAuthResponseModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory UserAuthResponseModel.fromMap(Map<String, dynamic> json) {
    return UserAuthResponseModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  UserAuthResponseModel copyWith({
    String? id,
    String? name,
    String? email,
  }) {
    return UserAuthResponseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  UserAuthEntity toEntity() {
    return UserAuthEntity(
      id: id,
      name: name,
      email: email,
    );
  }

  factory UserAuthResponseModel.fromEntity(UserAuthEntity entity) {
    return UserAuthResponseModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
