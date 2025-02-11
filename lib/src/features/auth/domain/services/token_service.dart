import 'package:dartz/dartz.dart';
import 'package:orders_sw/external/services/storage/storage_service.dart';
import 'package:orders_sw/src/core/exception/failure.dart';
import 'package:orders_sw/src/core/injection/injections.dart';
import 'package:orders_sw/src/core/injection/log/log.dart';
import 'package:orders_sw/src/core/injection/log/log_scope.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_token.dart';
import 'package:orders_sw/src/features/auth/domain/repositories/token_repository_impl.dart';

abstract class TokenService {
  Future<bool> isAuthenticated();
  UserTokenEntity? get token;
  String? get accessToken;
  Future<void> saveToken({required UserTokenEntity token});
  Future<void> clearToken();
  Future<UserTokenEntity?> getToken();
  Future<Either<Failure, UserTokenEntity?>> getRefreshToken(String token);
}

class TokenServiceImpl implements TokenService {
  final StorageService _storageService;

  TokenServiceImpl({
    required StorageService storageService,
  }) : _storageService = storageService {
    getToken();
  }

  UserTokenEntity? _currentToken;

  @override
  String? get accessToken => token?.accessToken;

  @override
  Future<bool> isAuthenticated() async {
    final token = await getToken();

    return token != null;
  }

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
  Future<Either<Failure, UserTokenEntity?>> getRefreshToken(String token) async {
    //Workaround to avoid circular dependency
    final repo = TokenRepositoryImpl(httpService: getIt());

    final repoResponse = await repo.refresh(token);

    return repoResponse.fold(
      (failure) {
        Log().error('Error refreshing token: $failure', name: LogScope.auth);
        return left(failure);
      },
      (token) {
        return right(token);
      },
    );
  }
}
