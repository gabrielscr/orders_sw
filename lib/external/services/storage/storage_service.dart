import 'package:dartz/dartz.dart';
import 'package:orders_sw/src/core/exception/failure.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_auth.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_token.dart';

abstract class StorageService {
  //User
  Future<Either<Failure, UserEntity?>> getUser();
  Future<Either<Failure, void>> saveUser(UserEntity user);
  Future<Either<Failure, void>> clearUser();

  //Token
  Future<Either<Failure, UserTokenEntity?>> getToken();
  Future<Either<Failure, void>> saveToken(UserTokenEntity token);
  Future<Either<Failure, void>> saveRefreshToken(UserTokenEntity token);
  Future<Either<Failure, void>> clearToken();
}
