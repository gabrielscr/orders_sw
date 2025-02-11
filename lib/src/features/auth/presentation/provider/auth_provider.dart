import 'dart:async';

import 'package:flutter/material.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_token_request.dart';
import 'package:orders_sw/src/features/auth/domain/usecases/generate_refresh_token_usecase.dart';
import 'package:orders_sw/src/features/auth/domain/usecases/generate_token_usecase.dart';
import 'package:orders_sw/src/features/auth/domain/usecases/get_user_usecase.dart';
import 'package:orders_sw/src/features/auth/domain/usecases/restore_session_usecase.dart';
import 'package:orders_sw/src/features/auth/domain/usecases/revoke_token_usecase.dart';
import 'package:orders_sw/src/features/auth/presentation/provider/auth_state.dart';

class AuthProvider extends ChangeNotifier {
  final GenerateTokenUsecase _generateTokenUsecase;
  final GenerateRefreshTokenUsecase _generateRefreshTokenUsecase;
  final RevokeTokenUsecase _revokeTokenUsecase;
  final GetUserUsecase _getUserUsecase;
  final RestoreSessionUsecase _restoreSessionUsecase;

  AuthProvider({
    required GenerateTokenUsecase generateTokenUsecase,
    required GenerateRefreshTokenUsecase generateRefreshTokenUsecase,
    required RevokeTokenUsecase revokeTokenUsecase,
    required GetUserUsecase getUserUsecase,
    required RestoreSessionUsecase restoreSessionUsecase,
  })  : _generateTokenUsecase = generateTokenUsecase,
        _generateRefreshTokenUsecase = generateRefreshTokenUsecase,
        _revokeTokenUsecase = revokeTokenUsecase,
        _getUserUsecase = getUserUsecase,
        _restoreSessionUsecase = restoreSessionUsecase {
    _updateState(AuthState.initial());
  }

  AuthState _state = const AuthState();

  AuthState get state => _state;

  void _updateState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> init() async {
    final result = await _restoreSessionUsecase();

    result.fold(
      (failure) {
        _updateState(
          AuthState.unauthenticated(),
        );
      },
      (token) => _updateState(
        AuthState.authenticated(),
      ),
    );
  }

  Future<void> generateToken({
    required String username,
    required String password,
  }) async {
    _updateState(AuthState.loading());

    final result = await _generateTokenUsecase(
      UserTokenRequestEntity(username: username, password: password),
    );

    result.fold(
      (failure) {
        if (failure.isBadRequest) {
          _updateState(
            AuthState.userError(),
          );

          return;
        }
        _updateState(
          AuthState.generalError(),
        );

        return;
      },
      (token) => _updateState(
        AuthState.authenticated(),
      ),
    );
  }

  Future<void> generateRefreshToken() async {
    final result = await _generateRefreshTokenUsecase(state.token!.refreshToken);

    result.fold(
      (failure) {
        _updateState(
          AuthState.unauthenticated(),
        );
      },
      (token) => _updateState(
        AuthState.authenticated(),
      ),
    );
  }

  Future<void> revokeToken() async {
    final result = await _revokeTokenUsecase(state.token!.accessToken);

    result.fold(
      (failure) {
        _updateState(
          AuthState.unauthenticated(),
        );
      },
      (token) => _updateState(
        AuthState.unauthenticated(),
      ),
    );
  }

  Future<void> getUser() async {
    final result = await _getUserUsecase();

    result.fold(
      (failure) {
        _updateState(
          AuthState.userError(),
        );
      },
      (user) => _updateState(
        state.copyWith(user: user),
      ),
    );
  }

  void resetState() {
    _updateState(AuthState.initial());
  }
}
