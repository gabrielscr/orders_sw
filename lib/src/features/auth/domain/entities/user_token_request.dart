import 'package:equatable/equatable.dart';

class UserTokenRequestEntity extends Equatable {
  final String username;
  final String password;

  const UserTokenRequestEntity({
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [username, password];
}

class UserTokenRefreshRequest extends Equatable {
  final String refreshToken;

  const UserTokenRefreshRequest({
    required this.refreshToken,
  });

  @override
  List<Object?> get props => [refreshToken];
}

class UserTokenRevokeRequest extends Equatable {
  final String token;

  const UserTokenRevokeRequest({
    required this.token,
  });

  @override
  List<Object?> get props => [token];
}
