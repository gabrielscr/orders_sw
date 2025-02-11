import 'package:dartz/dartz.dart';
import 'package:orders_sw/src/core/exception/failure.dart';
import 'package:orders_sw/src/features/auth/data/repositories/token_repository.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_token.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_token_request.dart';
import 'package:orders_sw/src/features/auth/domain/services/token_service.dart';

class GenerateTokenUsecase {
  final TokenRepository _tokenRepository;
  final TokenService _tokenService;

  const GenerateTokenUsecase({
    required TokenRepository tokenRepository,
    required TokenService tokenService,
  })  : _tokenRepository = tokenRepository,
        _tokenService = tokenService;

  Future<Either<Failure, UserTokenEntity>> call(UserTokenRequestEntity entity) async {
    final response = await _tokenRepository.generate(entity);

    response.fold((failure) {
      _tokenService.clearToken();

      return Left(failure);
    }, (token) {
      _tokenService.saveToken(token: token);

      return Right(token);
    });

    return response;
  }
}
