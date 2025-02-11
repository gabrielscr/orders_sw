import 'package:dartz/dartz.dart';
import 'package:orders_sw/src/core/constants/endpoints.dart';
import 'package:orders_sw/src/core/exception/failure.dart';
import 'package:orders_sw/src/core/external/network/exception_handler.dart';
import 'package:orders_sw/src/core/external/network/http_service.dart';
import 'package:orders_sw/src/features/auth/data/models/user_model.dart';
import 'package:orders_sw/src/features/auth/data/repositories/user_repository.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_auth.dart';

class UserRepositoryImpl implements UserRepository {
  final HttpService _httpService;

  UserRepositoryImpl({required HttpService httpService}) : _httpService = httpService;

  @override
  Future<Either<Failure, UserEntity>> me() async {
    try {
      final response = await _httpService.get(Endpoints.user);

      final user = UserModel.fromMap(response).toEntity();

      return Right(user);
    } on Exception catch (e) {
      return e.handleFailure();
    }
  }
}
