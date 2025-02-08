import 'dart:async';

import 'package:orders_sw/external/services/storage/storage_service.dart';
import 'package:orders_sw/src/core/injection/log/log.dart';
import 'package:orders_sw/src/core/injection/log/log_scope.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_auth.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_token.dart';

abstract class AuthService {
  UserAuthEntity? get user;
  UserTokenEntity? get token;
  Stream<UserAuthEntity?> get userStream;
  Stream<UserTokenEntity?> get tokenStream;
  String? get accessToken;
  bool get isAuthenticated;

  Future<void> saveUser({required UserAuthEntity user});
  Future<void> clearUser();

  Future<void> saveToken({required UserTokenEntity token});
  Future<void> clearToken();

  void dispose();
}

class AuthServiceImpl implements AuthService {
  final StorageService _storageService;

  AuthServiceImpl({required StorageService storageService}) : _storageService = storageService {
    _init();
  }

  final _userStreamController = StreamController<UserAuthEntity?>();
  final _tokenStreamController = StreamController<UserTokenEntity?>();

  UserAuthEntity? _currentUser;
  UserTokenEntity? _currentToken;

  @override
  Stream<UserAuthEntity?> get userStream => _userStreamController.stream;

  @override
  Stream<UserTokenEntity?> get tokenStream => _tokenStreamController.stream;

  @override
  String? get accessToken => token?.accessToken;

  @override
  bool get isAuthenticated => _currentUser != null && _currentToken != null;

  @override
  Future<void> saveUser({required UserAuthEntity user}) async {
    _updateUserStream(user);
    await _storageService.saveUser(user);
  }

  @override
  Future<void> clearUser() async {
    _clearUserStream();
    await _storageService.clearUser();
  }

  @override
  UserAuthEntity? get user => _currentUser;

  Future<void> _init() async {
    final userResult = await _storageService.getUser();

    final newUser = userResult.fold(
      (l) => null,
      (user) => user,
    );

    if (newUser != null) {
      _updateUserStream(newUser);
    }
  }

  void _updateUserStream(UserAuthEntity user) {
    try {
      _currentUser = user;
      _userStreamController.add(user);
    } on Exception catch (e) {
      Log().error(
        'Error updating user stream: $e',
        name: LogScope.auth,
      );
    }

    Log().info(
      'User updated: $user',
      name: LogScope.auth,
    );
  }

  void _clearUserStream() {
    Log().warning(
      'User cleared',
      name: LogScope.auth,
    );

    try {
      _userStreamController.add(null);
    } on Exception catch (e) {
      Log().error(
        'Error clearing user stream: $e',
        name: LogScope.auth,
      );
    }
  }

  @override
  Future<void> clearToken() async {
    _clearTokenStream();
    await _storageService.clearToken();
  }

  @override
  Future<void> saveToken({required UserTokenEntity token}) async {
    _currentToken = token;
    _updateTokenStream(token);
    await _storageService.saveToken(token);
  }

  @override
  UserTokenEntity? get token => _currentToken;

  void _clearTokenStream() {
    Log().warning(
      'Token cleared',
      name: LogScope.auth,
    );

    try {
      _tokenStreamController.add(null);
    } on Exception catch (e) {
      Log().error(
        'Error clearing token stream: $e',
        name: LogScope.auth,
      );
    }
  }

  void _updateTokenStream(UserTokenEntity token) {
    try {
      _tokenStreamController.add(token);
    } on Exception catch (e) {
      Log().error(
        'Error updating token stream: $e',
        name: LogScope.auth,
      );
    }

    Log().info(
      'Token updated: $token',
      name: LogScope.auth,
    );

    Log().info(
      'Access Token: ${token.accessToken}',
      name: LogScope.auth,
    );
  }

  @override
  void dispose() {
    _userStreamController.close();
    _tokenStreamController.close();
  }
}
