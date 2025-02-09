import 'package:dartz/dartz.dart';
import 'package:orders_sw/src/core/exception/api_exception.dart';
import 'package:orders_sw/src/core/exception/failure.dart';
import 'package:orders_sw/src/core/injection/log/log.dart';
import 'package:orders_sw/src/core/injection/log/log_scope.dart';

extension ExceptionHandler on Exception {
  Either<Failure, T> handleFailure<T>() {
    if (this is ApiException) {
      final e = this as ApiException;
      if (e.statusCode == 400) {
        return Left(Failure.badRequest());
      } else if (e.statusCode == 401) {
        return Left(Failure.unauthorized());
      } else if (e.statusCode == 403) {
        return Left(Failure.forbidden());
      }
    }

    Log().error(toString(), name: LogScope.repository);
    return Left(Failure.general());
  }
}
