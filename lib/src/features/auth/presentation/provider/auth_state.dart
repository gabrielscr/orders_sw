import 'package:equatable/equatable.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_auth.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_token.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_token_request.dart';

enum AuthStatus { authenticated, unauthenticated, loading, generalError, userError }

class AuthState extends Equatable {
  final AuthStatus status;
  final UserEntity? user;
  final UserTokenEntity? token;
  final UserTokenRequestEntity? userTokenRequest;

  const AuthState({
    this.status = AuthStatus.unauthenticated,
    this.user,
    this.token,
    this.userTokenRequest,
  });

  factory AuthState.initial() => const AuthState(
        status: AuthStatus.unauthenticated,
      );

  factory AuthState.authenticated({UserEntity? user, UserTokenEntity? token}) {
    return AuthState(
      status: AuthStatus.authenticated,
      user: user,
      token: token,
    );
  }

  factory AuthState.loading() {
    return const AuthState(
      status: AuthStatus.loading,
    );
  }

  factory AuthState.generalError() {
    return const AuthState(
      status: AuthStatus.generalError,
    );
  }

  factory AuthState.userError() {
    return const AuthState(
      status: AuthStatus.userError,
    );
  }

  factory AuthState.unauthenticated() {
    return const AuthState(
      status: AuthStatus.unauthenticated,
    );
  }

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    UserTokenEntity? token,
    UserTokenRequestEntity? userTokenRequest,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      token: token ?? this.token,
      userTokenRequest: userTokenRequest ?? this.userTokenRequest,
    );
  }

  @override
  List<Object?> get props => [status, user, token, userTokenRequest];
}
