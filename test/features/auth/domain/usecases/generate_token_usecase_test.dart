import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_token.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_token_request.dart';
import 'package:orders_sw/src/features/auth/domain/usecases/generate_token_usecase.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late MockTokenRepository tokenRepository;
  late GenerateTokenUsecase generateTokenUsecase;
  late MockTokenService tokenService;

  setUp(() {
    tokenRepository = MockTokenRepository();
    tokenService = MockTokenService();
    generateTokenUsecase = GenerateTokenUsecase(
      tokenRepository: tokenRepository,
      tokenService: tokenService,
    );
  });

  const userTokenRequest = UserTokenRequestEntity(
    username: 'username',
    password: 'password',
  );

  const userToken = UserTokenEntity(
    accessToken: 'accessToken',
    refreshToken: 'refreshToken',
    expiresIn: 300,
  );

  registerFallbackValue(userTokenRequest);
  registerFallbackValue(userToken);
  registerFallbackValue('token');

  test('should call generate token repository', () async {
    when(() => tokenRepository.generate(any())).thenAnswer((_) async => const Right(UserTokenEntity(accessToken: 'accessToken', refreshToken: 'refreshToken', expiresIn: 300)));
    when(() => tokenService.saveToken(token: any(named: 'token'))).thenAnswer((_) async => const Right(null));
    when(() => tokenService.clearToken()).thenAnswer((_) async => const Right(null));

    await generateTokenUsecase(userTokenRequest);

    verify(() => tokenRepository.generate(userTokenRequest)).called(1);
  });
}
