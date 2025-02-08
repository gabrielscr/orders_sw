import 'package:orders_sw/src/features/auth/domain/entities/user_token_request.dart';

class UserTokenRequestModel extends UserTokenRequestEntity {
  const UserTokenRequestModel({
    required super.username,
    required super.password,
  });

  factory UserTokenRequestModel.fromMap(Map<String, dynamic> json) {
    return UserTokenRequestModel(
      username: json['username'],
      password: json['password'],
    );
  }

  UserTokenRequestModel copyWith({
    String? username,
    String? password,
  }) {
    return UserTokenRequestModel(
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  factory UserTokenRequestModel.fromEntity(UserTokenRequestEntity entity) {
    return UserTokenRequestModel(
      username: entity.username,
      password: entity.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'grant_type': 'password',
      'client_id': 'user',
    };
  }

  UserTokenRequestEntity toEntity() {
    return UserTokenRequestEntity(
      username: username,
      password: password,
    );
  }
}
