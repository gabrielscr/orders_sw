import 'package:dartz/dartz.dart';
import 'package:orders_sw/src/core/exception/failure.dart';
import 'package:orders_sw/src/features/auth/data/repositories/token_repository.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_token.dart';

class GenerateRefreshTokenUsecase {
  final TokenRepository _tokenRepository;

  const GenerateRefreshTokenUsecase({
    required TokenRepository tokenRepository,
  }) : _tokenRepository = tokenRepository;

  Future<Either<Failure, UserTokenEntity?>> call(String refreshToken) async {
    return await _tokenRepository.refresh(refreshToken);
  }
}
