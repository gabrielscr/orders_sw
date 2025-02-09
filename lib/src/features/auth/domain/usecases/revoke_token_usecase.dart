import 'package:dartz/dartz.dart';
import 'package:orders_sw/src/core/exception/failure.dart';
import 'package:orders_sw/src/features/auth/data/repositories/token_repository.dart';

class RevokeTokenUsecase {
  final TokenRepository _tokenRepository;

  const RevokeTokenUsecase({
    required TokenRepository tokenRepository,
  }) : _tokenRepository = tokenRepository;

  Future<Either<Failure, Unit>> call(String token) async {
    return await _tokenRepository.revoke(token);
  }
}
