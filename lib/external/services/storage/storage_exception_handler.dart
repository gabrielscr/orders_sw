import 'package:dartz/dartz.dart';
import 'package:orders_sw/src/core/exception/failure.dart';
import 'package:orders_sw/src/core/injection/log/log.dart';
import 'package:orders_sw/src/core/injection/log/log_scope.dart';

extension ExceptionHandler on Exception {
  Either<Failure, T> handleStorageFailure<T>() {
    Log().error(
      'Error in StorageService',
      name: LogScope.storage,
      exception: this,
    );
    return Left(Failure.storageService());
  }
}
