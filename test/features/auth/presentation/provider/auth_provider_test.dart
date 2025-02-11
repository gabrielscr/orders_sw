import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:orders_sw/src/core/exception/failure.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_token.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_token_request.dart';
import 'package:orders_sw/src/features/auth/presentation/provider/auth_provider.dart';
import 'package:orders_sw/src/features/auth/presentation/provider/auth_state.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late AuthProvider authProvider;
  late MockGenerateTokenUsecase mockGenerateTokenUsecase;
  late MockRevokeTokenUsecase mockRevokeTokenUsecase;
  late MockGetUserUsecase mockGetUserUsecase;
  late MockRestoreSessionUsecase mockRestoreSessionUsecase;
  late MockTokenService mockTokenService;

  const userToken = UserTokenEntity(
    accessToken: 'token',
    refreshToken: 'refresh',
    expiresIn: 300,
  );

  const userTokenRequest = UserTokenRequestEntity(
    username: 'username',
    password: 'password',
  );

  setUp(() {
    mockGenerateTokenUsecase = MockGenerateTokenUsecase();
    mockRevokeTokenUsecase = MockRevokeTokenUsecase();
    mockGetUserUsecase = MockGetUserUsecase();
    mockRestoreSessionUsecase = MockRestoreSessionUsecase();
    mockTokenService = MockTokenService();

    authProvider = AuthProvider(
      generateTokenUsecase: mockGenerateTokenUsecase,
      revokeTokenUsecase: mockRevokeTokenUsecase,
      getUserUsecase: mockGetUserUsecase,
      restoreSessionUsecase: mockRestoreSessionUsecase,
      tokenService: mockTokenService,
    );

    registerFallbackValue(userTokenRequest);
  });

  test('Should init auth provider', () {
    expect(authProvider.state, AuthState.initial());
    expect(authProvider.isAuthenticated, false);
  });

  test('should call init without errors', () async {
    when(() => mockRestoreSessionUsecase()).thenAnswer(
      (_) async => const Right(userToken),
    );

    await authProvider.init();

    expect(authProvider.state, AuthState.authenticated(token: userToken));
  });

  test('should call init with errors', () async {
    when(() => mockRestoreSessionUsecase()).thenAnswer(
      (_) async => Left(Failure.badRequest()),
    );

    await authProvider.init();

    expect(authProvider.state, AuthState.unauthenticated());
  });
}
