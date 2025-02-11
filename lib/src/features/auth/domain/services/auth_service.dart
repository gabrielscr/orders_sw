import 'dart:async';

import 'package:orders_sw/external/services/storage/storage_service.dart';
import 'package:orders_sw/src/core/injection/log/log.dart';
import 'package:orders_sw/src/core/injection/log/log_scope.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_auth.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_token.dart';

abstract class AuthService {
  UserEntity? get user;
  UserTokenEntity? get token;
  String? get accessToken;
  Future<bool> isAuthenticated();

  Future<void> saveUser({required UserEntity user});
  Future<void> clearUser();
  Future<UserEntity?> getUser();

  Future<void> saveToken({required UserTokenEntity token});
  Future<void> clearToken();
  Future<UserTokenEntity?> getToken();
}

class AuthServiceImpl implements AuthService {
  final StorageService _storageService;

  AuthServiceImpl({required StorageService storageService}) : _storageService = storageService {
    getToken();
    getUser();
  }

  UserEntity? _currentUser;
  UserTokenEntity? _currentToken;

  @override
  String? get accessToken => token?.accessToken;

  @override
  Future<bool> isAuthenticated() async {
    final token = await getToken();

    return token != null;
  }

  @override
  Future<void> saveUser({required UserEntity user}) async {
    await _storageService.saveUser(user);
  }

  @override
  Future<void> clearUser() async {
    await _storageService.clearUser();
  }

  @override
  UserEntity? get user => _currentUser;

  @override
  Future<void> clearToken() async {
    await _storageService.clearToken();
  }

  @override
  Future<void> saveToken({required UserTokenEntity token}) async {
    _currentToken = token;
    await _storageService.saveToken(token);
  }

  @override
  UserTokenEntity? get token => _currentToken;

  @override
  Future<UserTokenEntity?> getToken() async {
    final tokenResult = await _storageService.getToken();

    tokenResult.fold(
      (failure) {
        Log().error('Error getting token: $failure', name: LogScope.auth);
      },
      (token) {
        _currentToken = token;
      },
    );

    return _currentToken;
  }

  @override
  Future<UserEntity?> getUser() async {
    final userResult = await _storageService.getUser();

    userResult.fold(
      (failure) {
        Log().error('Error getting user: $failure', name: LogScope.auth);
      },
      (user) {
        _currentUser = user;
      },
    );

    return _currentUser;
  }
}
