import 'package:dartz/dartz.dart';
import 'package:orders_sw/src/core/exception/failure.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_token.dart';
import 'package:orders_sw/src/features/auth/domain/services/auth_service.dart';

class RestoreSessionUsecase {
  final AuthService _authService;

  const RestoreSessionUsecase({
    required AuthService authService,
  }) : _authService = authService;

  Future<Either<Failure, UserTokenEntity>> call() async {
    final result = await _authService.getToken();

    if (result == null) {
      return Left(Failure.unauthorized());
    } else {
      return Right(result);
    }
  }
}
