import 'package:dartz/dartz.dart';
import 'package:orders_sw/src/core/constants/endpoints.dart';
import 'package:orders_sw/src/core/exception/failure.dart';
import 'package:orders_sw/src/core/external/network/exception_handler.dart';
import 'package:orders_sw/src/core/external/network/http_service.dart';
import 'package:orders_sw/src/features/auth/data/models/user_token_request_model.dart';
import 'package:orders_sw/src/features/auth/data/models/user_token_response_model.dart';
import 'package:orders_sw/src/features/auth/data/repositories/token_repository.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_token.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_token_request.dart';

class TokenRepositoryImpl implements TokenRepository {
  final HttpService _httpService;

  TokenRepositoryImpl({required HttpService httpService}) : _httpService = httpService;

  @override
  Future<Either<Failure, UserTokenEntity>> generate(UserTokenRequestEntity entity) async {
    try {
      final response = await _httpService.postForTokenOnly(
        Endpoints.emitToken,
        body: UserTokenRequestModel.fromEntity(entity).toMap(),
      );

      final token = UserTokenResponseModel.fromMap(response).toEntity();

      return Right(token);
    } on Exception catch (e) {
      return e.handleFailure();
    }
  }

  @override
  Future<Either<Failure, UserTokenEntity>> refresh(String token) async {
    try {
      final response = await _httpService.postForTokenOnly(
        Endpoints.refreshToken,
        body: UserTokenRefreshRequestModel(refreshToken: token).toMap(),
      );

      final tokenResponse = UserTokenResponseModel.fromMap(response).toEntity();

      return Right(tokenResponse);
    } on Exception catch (e) {
      return e.handleFailure();
    }
  }

  @override
  Future<Either<Failure, Unit>> revoke(String token) async {
    try {
      await _httpService.postForTokenOnly(
        Endpoints.revokeToken,
        body: UserTokenRevokeRequestModel(token: token).toMap(),
      );

      return const Right(unit);
    } on Exception catch (e) {
      return e.handleFailure();
    }
  }
}
