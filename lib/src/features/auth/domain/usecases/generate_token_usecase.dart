import 'package:dartz/dartz.dart';
import 'package:orders_sw/src/core/exception/failure.dart';
import 'package:orders_sw/src/features/auth/data/repositories/token_repository.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_token.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_token_request.dart';
import 'package:orders_sw/src/features/auth/domain/services/auth_service.dart';

class GenerateTokenUsecase {
  final TokenRepository _tokenRepository;
  final AuthService _authService;

  const GenerateTokenUsecase({
    required TokenRepository tokenRepository,
    required AuthService authService,
  })  : _tokenRepository = tokenRepository,
        _authService = authService;

  Future<Either<Failure, UserTokenEntity>> call(UserTokenRequestEntity entity) async {
    final response = await _tokenRepository.generate(entity);

    response.fold((failure) {
      _authService.clearToken();

      return Left(failure);
    }, (token) {
      _authService.saveToken(token: token);

      return Right(token);
    });

    return response;
  }
}
