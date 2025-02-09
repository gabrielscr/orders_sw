import 'package:dartz/dartz.dart';
import 'package:orders_sw/src/core/constants/endpoints.dart';
import 'package:orders_sw/src/core/exception/api_exception.dart';
import 'package:orders_sw/src/core/exception/failure.dart';
import 'package:orders_sw/src/core/external/network/http_service.dart';
import 'package:orders_sw/src/core/injection/log/log.dart';
import 'package:orders_sw/src/core/injection/log/log_scope.dart';
import 'package:orders_sw/src/features/auth/data/models/user_token_request_model.dart';
import 'package:orders_sw/src/features/auth/data/repositories/token_repository.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_token_request.dart';

class TokenRepositoryImpl implements TokenRepository {
  final HttpService _httpService;

  TokenRepositoryImpl({required HttpService httpService}) : _httpService = httpService;

  @override
  Future<Either<Failure, UserTokenRequestEntity>> generate() async {
    try {
      final response = await _httpService.post(Endpoints.emitToken);

      final token = UserTokenRequestModel.fromMap(response.data).toEntity();

      return Right(token);
    } on ApiException catch (e) {
      if (e.statusCode == 400) {
        return Left(Failure.badRequest());
      } else if (e.statusCode == 401) {
        return Left(Failure.unauthorized());
      } else if (e.statusCode == 403) {
        return Left(Failure.forbidden());
      }

      return Left(Failure.general());
    } on Exception catch (e) {
      Log().error(e.toString(), name: LogScope.repository);

      return Left(Failure.general());
    }
  }

  @override
  Future<Either<Failure, UserTokenRefreshRequest>> refresh(String token) async {
    try {
      final response = await _httpService.post(Endpoints.refreshToken, body: {'token': token});

      final tokenResponse = UserTokenRefreshRequestModel.fromMap(response.data).toEntity();

      return Right(tokenResponse);
    } on ApiException catch (e) {
      if (e.statusCode == 400) {
        return Left(Failure.badRequest());
      } else if (e.statusCode == 401) {
        return Left(Failure.unauthorized());
      } else if (e.statusCode == 403) {
        return Left(Failure.forbidden());
      }

      return Left(Failure.general());
    } on Exception catch (e) {
      Log().error(e.toString(), name: LogScope.repository);

      return Left(Failure.general());
    }
  }

  @override
  Future<Either<Failure, Unit>> revoke(String token) async {
    // TODO: implement revoke
    throw UnimplementedError();
  }
}
