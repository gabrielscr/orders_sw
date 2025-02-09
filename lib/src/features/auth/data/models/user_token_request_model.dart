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

class UserTokenRefreshRequestModel extends UserTokenRefreshRequest {
  const UserTokenRefreshRequestModel({required super.refreshToken});

  factory UserTokenRefreshRequestModel.fromMap(Map<String, dynamic> json) {
    return UserTokenRefreshRequestModel(
      refreshToken: json['refreshToken'],
    );
  }

  factory UserTokenRefreshRequestModel.fromEntity(UserTokenRefreshRequest entity) {
    return UserTokenRefreshRequestModel(
      refreshToken: entity.refreshToken,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'refreshToken': refreshToken,
      'grant_type': 'refresh_token',
      'client_id': 'user',
    };
  }

  UserTokenRefreshRequest toEntity() {
    return UserTokenRefreshRequest(
      refreshToken: refreshToken,
    );
  }
}

class UserTokenRevokeRequestModel extends UserTokenRevokeRequest {
  const UserTokenRevokeRequestModel({required super.token});

  factory UserTokenRevokeRequestModel.fromMap(Map<String, dynamic> json) {
    return UserTokenRevokeRequestModel(
      token: json['token'],
    );
  }

  factory UserTokenRevokeRequestModel.fromEntity(UserTokenRevokeRequest entity) {
    return UserTokenRevokeRequestModel(
      token: entity.token,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'client_id': 'user',
      'token_type_hint': 'refresh_token',
    };
  }

  UserTokenRevokeRequest toEntity() {
    return UserTokenRevokeRequest(
      token: token,
    );
  }
}
