import 'package:dartz/dartz.dart';
import 'package:orders_sw/src/core/exception/failure.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_token.dart';
import 'package:orders_sw/src/features/auth/domain/services/token_service.dart';

class RestoreSessionUsecase {
  final TokenService _tokenService;

  const RestoreSessionUsecase({
    required TokenService tokenService,
  }) : _tokenService = tokenService;

  Future<Either<Failure, UserTokenEntity>> call() async {
    final result = await _tokenService.getToken();

    if (result == null) {
      return Left(Failure.unauthorized());
    } else {
      return Right(result);
    }
  }
}
