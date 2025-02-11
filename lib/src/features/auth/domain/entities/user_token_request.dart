import 'package:equatable/equatable.dart';
import 'package:orders_sw/src/core/utils/utils.dart';

class UserTokenRequestEntity extends Equatable {
  final String username;
  final String password;

  const UserTokenRequestEntity({
    required this.username,
    required this.password,
  });

  bool get isValidUsername => isValidEmail(username);

  bool get isValid => username.isNotEmpty && password.isNotEmpty && isValidEmail(username);

  UserTokenRequestEntity copyWith({
    String? username,
    String? password,
  }) {
    return UserTokenRequestEntity(
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

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
