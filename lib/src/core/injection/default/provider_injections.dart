import 'package:get_it/get_it.dart';
import 'package:orders_sw/src/core/injection/injections.dart';
import 'package:orders_sw/src/features/auth/presentation/provider/auth_provider.dart';
import 'package:orders_sw/src/features/order/presentation/viewmodels/order_provider.dart';

class ProviderInjections implements Injection {
  @override
  Future<void> inject(GetIt getIt) async {
    getIt.registerFactory(
      () => AuthProvider(
        generateTokenUsecase: getIt(),
        revokeTokenUsecase: getIt(),
        getUserUsecase: getIt(),
        restoreSessionUsecase: getIt(),
      ),
    );

    getIt.registerFactory(
      () => OrderProvider(
        getOrdersUsecase: getIt(),
        finishOrderUsecase: getIt(),
        createOrderUsecase: getIt(),
      ),
    );

    return;
  }
}
