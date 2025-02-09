import 'package:dartz/dartz.dart';
import 'package:orders_sw/src/core/exception/failure.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_auth.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> me();
}
