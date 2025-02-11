import 'dart:async';

import 'package:orders_sw/external/services/storage/storage_service.dart';
import 'package:orders_sw/src/core/injection/log/log.dart';
import 'package:orders_sw/src/core/injection/log/log_scope.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_auth.dart';

abstract class AuthService {
  UserEntity? get user;

  Future<void> saveUser({required UserEntity user});
  Future<void> clearUser();
  Future<UserEntity?> getUser();
}

class AuthServiceImpl implements AuthService {
  final StorageService _storageService;

  AuthServiceImpl({
    required StorageService storageService,
  }) : _storageService = storageService {
    getUser();
  }

  UserEntity? _currentUser;

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
