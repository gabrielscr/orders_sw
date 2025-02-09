import 'package:orders_sw/src/features/auth/domain/entities/user_request.dart';

class UserRequestModel extends UserRequestEntity {
  const UserRequestModel({
    required super.email,
    required super.password,
  });

  factory UserRequestModel.fromMap(Map<String, dynamic> json) {
    return UserRequestModel(
      email: json['email'],
      password: json['password'],
    );
  }

  UserRequestModel copyWith({
    String? email,
    String? password,
  }) {
    return UserRequestModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  factory UserRequestModel.fromEntity(UserRequestEntity entity) {
    return UserRequestModel(
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
