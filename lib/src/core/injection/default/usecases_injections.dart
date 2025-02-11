import 'package:get_it/get_it.dart';
import 'package:orders_sw/src/core/injection/injections.dart';
import 'package:orders_sw/src/features/auth/domain/usecases/generate_refresh_token_usecase.dart';
import 'package:orders_sw/src/features/auth/domain/usecases/generate_token_usecase.dart';
import 'package:orders_sw/src/features/auth/domain/usecases/get_user_usecase.dart';
import 'package:orders_sw/src/features/auth/domain/usecases/restore_session_usecase.dart';
import 'package:orders_sw/src/features/auth/domain/usecases/revoke_token_usecase.dart';
import 'package:orders_sw/src/features/order/domain/usecases/create_order_usecase.dart';
import 'package:orders_sw/src/features/order/domain/usecases/finish_order_usecase.dart';
import 'package:orders_sw/src/features/order/domain/usecases/get_orders_usecase.dart';

class UsecasesInjections implements Injection {
  @override
  Future<void> inject(GetIt getIt) async {
    getIt.registerFactory<GenerateTokenUsecase>(() => GenerateTokenUsecase(tokenRepository: getIt(), tokenService: getIt()));
    getIt.registerFactory<GenerateRefreshTokenUsecase>(() => GenerateRefreshTokenUsecase(tokenRepository: getIt()));
    getIt.registerFactory<RevokeTokenUsecase>(() => RevokeTokenUsecase(tokenRepository: getIt(), tokenService: getIt()));
    getIt.registerFactory<GetUserUsecase>(() => GetUserUsecase(authRepository: getIt()));
    getIt.registerFactory<RestoreSessionUsecase>(() => RestoreSessionUsecase(tokenService: getIt()));

    getIt.registerFactory<GetOrdersUsecase>(() => GetOrdersUsecase(orderRepository: getIt()));
    getIt.registerFactory<FinishOrderUsecase>(() => FinishOrderUsecase(orderRepository: getIt()));
    getIt.registerFactory<CreateOrderUsecase>(() => CreateOrderUsecase(orderRepository: getIt()));

    return;
  }
}
