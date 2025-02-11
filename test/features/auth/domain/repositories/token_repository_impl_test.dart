import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:orders_sw/src/features/auth/data/models/user_token_request_model.dart';
import 'package:orders_sw/src/features/auth/domain/repositories/token_repository_impl.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late MockHttpService mockHttpService;
  late TokenRepositoryImpl tokenRepositoryImpl;

  setUp(() {
    mockHttpService = MockHttpService();
    tokenRepositoryImpl = TokenRepositoryImpl(httpService: mockHttpService);
  });

  group('Token Repository tests', () {
    test('Should return a UserTokenEntity when generate is called', () async {
      final jsonRequest = {
        'username': 'username',
        'password': 'password',
      };

      final jsonResponse = {
        'access_token': 'access',
        'refresh_token': 'refresh',
        'expires_in': 300,
      };

      final request = UserTokenRequestModel.fromMap(jsonRequest);

      when(() => mockHttpService.postForTokenOnly(any(), body: any(named: 'body'))).thenAnswer((_) async => jsonResponse);

      final result = await tokenRepositoryImpl.generate(request);

      expect(result.isRight(), true);

      verify(() => mockHttpService.postForTokenOnly(any(), body: any(named: 'body'))).called(1);
    });

    test('Should return a UserTokenEntity when refresh is called', () async {
      final jsonResponse = {
        'access_token': 'access',
        'refresh_token': 'refresh',
        'expires_in': 300,
      };

      when(() => mockHttpService.postForTokenOnly(any(), body: any(named: 'body'))).thenAnswer((_) async => jsonResponse);

      final result = await tokenRepositoryImpl.refresh('refresh');

      expect(result.isRight(), true);

      verify(() => mockHttpService.postForTokenOnly(any(), body: any(named: 'body'))).called(1);
    });

    test('Should return a Unit when revoke is called', () async {
      when(() => mockHttpService.postForTokenOnly(any(), body: any(named: 'body'))).thenAnswer((_) async => {});

      final result = await tokenRepositoryImpl.revoke('token');

      expect(result.isRight(), true);

      verify(() => mockHttpService.postForTokenOnly(any(), body: any(named: 'body'))).called(1);
    });

    test('Should return a Failure when generate throws an exception', () async {
      final jsonRequest = {
        'username': 'username',
        'password': 'password',
      };

      final request = UserTokenRequestModel.fromMap(jsonRequest);

      when(() => mockHttpService.postForTokenOnly(any(), body: any(named: 'body'))).thenThrow(Exception());

      final result = await tokenRepositoryImpl.generate(request);

      expect(result.isLeft(), true);

      verify(() => mockHttpService.postForTokenOnly(any(), body: any(named: 'body'))).called(1);
    });

    test('Should return a Failure when refresh throws an exception', () async {
      when(() => mockHttpService.postForTokenOnly(any(), body: any(named: 'body'))).thenThrow(Exception());

      final result = await tokenRepositoryImpl.refresh('refresh');

      expect(result.isLeft(), true);

      verify(() => mockHttpService.postForTokenOnly(any(), body: any(named: 'body'))).called(1);
    });

    test('Should return a Failure when revoke throws an exception', () async {
      when(() => mockHttpService.postForTokenOnly(any(), body: any(named: 'body'))).thenThrow(Exception());

      final result = await tokenRepositoryImpl.revoke('token');

      expect(result.isLeft(), true);

      verify(() => mockHttpService.postForTokenOnly(any(), body: any(named: 'body'))).called(1);
    });
    
  });
}
