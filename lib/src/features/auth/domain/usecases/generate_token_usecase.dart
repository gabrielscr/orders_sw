import 'package:dartz/dartz.dart';
import 'package:orders_sw/src/core/exception/failure.dart';
import 'package:orders_sw/src/features/auth/data/repositories/token_repository.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_token_request.dart';

class GenerateTokenUsecase {
  final TokenRepository _tokenRepository;

  const GenerateTokenUsecase({
    required TokenRepository tokenRepository,
  }) : _tokenRepository = tokenRepository;

  Future<Either<Failure, UserTokenRequestEntity>> call(UserTokenRequestEntity entity) async {
    return await _tokenRepository.generate(entity);
  }
}
