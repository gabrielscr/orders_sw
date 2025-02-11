import 'dart:async';

import 'package:flutter/material.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_token.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_token_request.dart';
import 'package:orders_sw/src/features/auth/domain/services/token_service.dart';
import 'package:orders_sw/src/features/auth/domain/usecases/generate_token_usecase.dart';
import 'package:orders_sw/src/features/auth/domain/usecases/get_user_usecase.dart';
import 'package:orders_sw/src/features/auth/domain/usecases/restore_session_usecase.dart';
import 'package:orders_sw/src/features/auth/domain/usecases/revoke_token_usecase.dart';
import 'package:orders_sw/src/features/auth/presentation/provider/auth_state.dart';

class AuthProvider extends ChangeNotifier {
  final GenerateTokenUsecase _generateTokenUsecase;
  final RevokeTokenUsecase _revokeTokenUsecase;
  final GetUserUsecase _getUserUsecase;
  final RestoreSessionUsecase _restoreSessionUsecase;
  final TokenService _tokenService;

  AuthProvider({
    required GenerateTokenUsecase generateTokenUsecase,
    required RevokeTokenUsecase revokeTokenUsecase,
    required GetUserUsecase getUserUsecase,
    required RestoreSessionUsecase restoreSessionUsecase,
    required TokenService tokenService,
  })  : _generateTokenUsecase = generateTokenUsecase,
        _revokeTokenUsecase = revokeTokenUsecase,
        _getUserUsecase = getUserUsecase,
        _restoreSessionUsecase = restoreSessionUsecase,
        _tokenService = tokenService {
    _updateState(AuthState.initial());
    _tokenService.addListener(_onTokenChanged);
  }

  AuthState _state = const AuthState();

  AuthState get state => _state;

  late UserTokenEntity userToken;

  bool isAuthenticated = false;

  void _onTokenChanged() {
    isAuthenticated = _tokenService.isAuthenticated;

    _updateState(isAuthenticated ? AuthState.authenticated() : AuthState.unauthenticated());
    notifyListeners();
  }

  @override
  void dispose() {
    _tokenService.removeListener(_onTokenChanged);
    super.dispose();
  }

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
      (token) {
        userToken = token;
        _updateState(
          AuthState.authenticated(token: token),
        );
      },
    );

    notifyListeners();
  }

  Future<void> generateToken({
    required String username,
    required String password,
  }) async {
    _updateState(AuthState.loading());

    final result = await _generateTokenUsecase(
      UserTokenRequestEntity(username: username, password: password),
    );

    result.fold((failure) {
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
    }, (token) {
      userToken = token;
      _updateState(
        AuthState.authenticated(token: token),
      );
    });

    notifyListeners();

    resetState();
  }

  Future<void> revokeToken({required UserTokenEntity token}) async {
    _updateState(
      AuthState.loading(),
    );

    final result = await _revokeTokenUsecase(token.accessToken);

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

    notifyListeners();
  }

  Future<void> getUser() async {
    _updateState(
      AuthState.loading(),
    );

    final result = await _getUserUsecase();

    result.fold(
      (failure) {
        _updateState(
          AuthState.userError(),
        );
      },
      (user) => _updateState(
        AuthState.authenticated(user: user, token: userToken),
      ),
    );

    notifyListeners();
  }

  void resetState() {
    _updateState(AuthState.initial());
  }
}
