import 'package:get_it/get_it.dart';
import 'package:orders_sw/src/core/injection/injections.dart';
import 'package:orders_sw/src/features/auth/data/repositories/token_repository.dart';
import 'package:orders_sw/src/features/auth/data/repositories/user_repository.dart';
import 'package:orders_sw/src/features/auth/domain/repositories/token_repository_impl.dart';
import 'package:orders_sw/src/features/auth/domain/repositories/user_repository_impl.dart';

class RepositoryInjections implements Injection {
  @override
  Future<void> inject(GetIt getIt) async {
    getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(httpService: getIt()));
    getIt.registerLazySingleton<TokenRepository>(() => TokenRepositoryImpl(httpService: getIt()));
  }
}
