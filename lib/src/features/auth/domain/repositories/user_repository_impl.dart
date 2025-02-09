import 'package:dartz/dartz.dart';
import 'package:orders_sw/src/core/constants/endpoints.dart';
import 'package:orders_sw/src/core/exception/api_exception.dart';
import 'package:orders_sw/src/core/exception/failure.dart';
import 'package:orders_sw/src/core/external/network/http_service.dart';
import 'package:orders_sw/src/core/injection/log/log.dart';
import 'package:orders_sw/src/core/injection/log/log_scope.dart';
import 'package:orders_sw/src/features/auth/data/models/user_auth_response_model.dart';
import 'package:orders_sw/src/features/auth/data/repositories/user_repository.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_auth.dart';

class UserRepositoryImpl implements UserRepository {
  final HttpService _httpService;

  UserRepositoryImpl({required HttpService httpService}) : _httpService = httpService;

  @override
  Future<Either<Failure, UserAuthEntity>> me() async {
    try {
      final response = await _httpService.get(Endpoints.user);

      final user = UserAuthResponseModel.fromMap(response.data).toEntity();

      return Right(user);
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
}
