import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:orders_sw/external/services/storage/storage_service.dart';
import 'package:orders_sw/src/core/exception/failure.dart';
import 'package:orders_sw/src/core/injection/injections.dart';
import 'package:orders_sw/src/core/injection/log/log.dart';
import 'package:orders_sw/src/core/injection/log/log_scope.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_token.dart';
import 'package:orders_sw/src/features/auth/domain/repositories/token_repository_impl.dart';

abstract class TokenService extends ChangeNotifier {
  bool get isAuthenticated;
  Future<void> saveToken({required UserTokenEntity token});
  Future<void> clearToken();
  Future<UserTokenEntity?> getToken();
  Future<Either<Failure, UserTokenEntity?>> getRefreshToken(String token);
}

class TokenServiceImpl extends ChangeNotifier implements TokenService {
  final StorageService _storageService;

  bool _isAuthenticated = false;

  TokenServiceImpl({required StorageService storageService}) : _storageService = storageService {
    _initialize();
  }

  UserTokenEntity? _currentToken;

  @override
  bool get isAuthenticated => _isAuthenticated;

  Future<void> _initialize() async {
    await getToken();
    notifyListeners();
  }

  @override
  Future<void> clearToken() async {
    await _storageService.clearToken();
    _isAuthenticated = false;
    notifyListeners();
  }

  @override
  Future<void> saveToken({required UserTokenEntity token}) async {
    _currentToken = token;
    await _storageService.saveToken(token);

    _isAuthenticated = true;
    notifyListeners();
  }

  @override
  Future<UserTokenEntity?> getToken() async {
    final tokenResult = await _storageService.getToken();

    tokenResult.fold(
      (failure) {
        Log().error('Error getting token: $failure', name: LogScope.auth);
      },
      (token) {
        _currentToken = token;
        _isAuthenticated = token != null;
        notifyListeners();
      },
    );

    return _currentToken;
  }

  @override
  Future<Either<Failure, UserTokenEntity?>> getRefreshToken(String token) async {
    final repo = TokenRepositoryImpl(httpService: getIt());

    final repoResponse = await repo.refresh(token);

    return repoResponse.fold(
      (failure) {
        Log().error('Error refreshing token', name: LogScope.auth);
        return left(failure);
      },
      (token) {
        _isAuthenticated = true;
        notifyListeners();
        return right(token);
      },
    );
  }
}
