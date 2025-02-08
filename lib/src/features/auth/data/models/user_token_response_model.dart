import 'package:orders_sw/src/features/auth/domain/entities/user_token.dart';

class UserTokenResponseModel extends UserTokenEntity {
  const UserTokenResponseModel({
    required super.accessToken,
    required super.refreshToken,
    required super.expiresIn,
  });

  factory UserTokenResponseModel.fromMap(Map<String, dynamic> json) {
    return UserTokenResponseModel(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      expiresIn: json['expires_in'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_in': expiresIn,
    };
  }

  UserTokenEntity toEntity() {
    return UserTokenEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: expiresIn,
    );
  }

  factory UserTokenResponseModel.fromEntity(UserTokenEntity entity) {
    return UserTokenResponseModel(
      accessToken: entity.accessToken,
      refreshToken: entity.refreshToken,
      expiresIn: entity.expiresIn,
    );
  }
}
