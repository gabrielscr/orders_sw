import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:orders_sw/src/features/auth/domain/usecases/generate_refresh_token_usecase.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late MockTokenRepository tokenRepository;
  late GenerateRefreshTokenUsecase generateRefreshTokenUsecase;

  setUp(() {
    tokenRepository = MockTokenRepository();
    generateRefreshTokenUsecase = GenerateRefreshTokenUsecase(tokenRepository: tokenRepository);
  });

  test('should call refresh token repository', () async {
    when(() => tokenRepository.refresh(any())).thenAnswer((_) async => const Right(null));

    const refreshToken = 'refreshToken';

    await generateRefreshTokenUsecase(refreshToken);

    verify(() => tokenRepository.refresh(refreshToken)).called(1);
  });
}
