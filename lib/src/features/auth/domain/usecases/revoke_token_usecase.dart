import 'package:dartz/dartz.dart';
import 'package:orders_sw/src/core/exception/failure.dart';
import 'package:orders_sw/src/features/auth/data/repositories/token_repository.dart';
import 'package:orders_sw/src/features/auth/domain/services/token_service.dart';

class RevokeTokenUsecase {
  final TokenRepository _tokenRepository;
  final TokenService _tokenService;

  const RevokeTokenUsecase({
    required TokenRepository tokenRepository,
    required TokenService tokenService,
  })  : _tokenRepository = tokenRepository,
        _tokenService = tokenService;

  Future<Either<Failure, Unit>> call(String token) async {
    final response = await _tokenRepository.revoke(token);

    return response.fold(
      (l) => Left(l),
      (r) {
        _tokenService.clearToken();
        return const Right(unit);
      },
    );
  }
}
