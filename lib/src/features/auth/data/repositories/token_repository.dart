import 'package:dartz/dartz.dart';
import 'package:orders_sw/src/core/exception/failure.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_token.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_token_request.dart';

abstract class TokenRepository {
  Future<Either<Failure, UserTokenEntity>> generate(UserTokenRequestEntity entity);
  Future<Either<Failure, UserTokenRefreshRequest>> refresh(String token);
  Future<Either<Failure, Unit>> revoke(String token);
}
