import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:orders_sw/external/services/secure_storage/secure_storage.dart';
import 'package:orders_sw/external/services/storage/storage_service.dart';
import 'package:orders_sw/src/core/exception/failure.dart';
import 'package:orders_sw/src/core/external/network/http_service.dart';
import 'package:orders_sw/src/features/auth/data/repositories/token_repository.dart';
import 'package:orders_sw/src/features/auth/data/repositories/user_repository.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_token.dart';
import 'package:orders_sw/src/features/auth/domain/services/auth_service.dart';
import 'package:orders_sw/src/features/auth/domain/services/token_service.dart';
import 'package:orders_sw/src/features/auth/domain/usecases/generate_token_usecase.dart';
import 'package:orders_sw/src/features/auth/domain/usecases/get_user_usecase.dart';
import 'package:orders_sw/src/features/auth/domain/usecases/restore_session_usecase.dart';
import 'package:orders_sw/src/features/auth/domain/usecases/revoke_token_usecase.dart';
import 'package:orders_sw/src/features/auth/presentation/provider/auth_provider.dart';

class MockHttpService extends Mock implements HttpService {}

class MockTokenRepository extends Mock implements TokenRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockAuthService extends Mock implements AuthService {}

class MockTokenService extends Mock implements TokenService {}

class MockAuthProvider extends Mock implements AuthProvider {}

class MockSecureStorage extends Mock implements SecureStorage {}

class RouteFake extends Fake implements Route {}

class MockRestoreSessionUsecase extends Mock implements RestoreSessionUsecase {}

class MockGenerateTokenUsecase extends Mock implements GenerateTokenUsecase {}

class MockRevokeTokenUsecase extends Mock implements RevokeTokenUsecase {}

class MockGetUserUsecase extends Mock implements GetUserUsecase {}

class MockStorageService extends Mock implements StorageService {
  final SecureStorage secureStorage;

  MockStorageService({required SecureStorage secure}) : secureStorage = secure;

  @override
  Future<Either<Failure, void>> clearToken() async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> saveToken(UserTokenEntity token) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, UserTokenEntity?>> getToken() async {
    return const Right(
      UserTokenEntity(
        accessToken: 'accessToken',
        refreshToken: 'refreshToken',
        expiresIn: 300,
      ),
    );
  }
}

class Fixtures {}
