import 'package:dartz/dartz.dart';
import 'package:orders_sw/src/core/exception/failure.dart';
import 'package:orders_sw/src/features/auth/data/repositories/user_repository.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_auth.dart';

class GetUserUsecase {
  final UserRepository _userRepository;

  const GetUserUsecase({
    required UserRepository authRepository,
  }) : _userRepository = authRepository;

  Future<Either<Failure, UserEntity>> call() async {
    return await _userRepository.me();
  }
}
