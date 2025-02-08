import 'package:orders_sw/src/features/auth/domain/entities/user_auth_request.dart';

class UserAuthRequestModel extends UserAuthRequestEntity {
  const UserAuthRequestModel({
    required super.email,
    required super.password,
  });

  factory UserAuthRequestModel.fromMap(Map<String, dynamic> json) {
    return UserAuthRequestModel(
      email: json['email'],
      password: json['password'],
    );
  }

  UserAuthRequestModel copyWith({
    String? email,
    String? password,
  }) {
    return UserAuthRequestModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  factory UserAuthRequestModel.fromEntity(UserAuthRequestEntity entity) {
    return UserAuthRequestModel(
      email: entity.email,
      password: entity.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }
}
