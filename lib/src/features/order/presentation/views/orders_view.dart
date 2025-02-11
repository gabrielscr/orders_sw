import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orders_sw/src/core/constants/app_constants.dart';
import 'package:orders_sw/src/core/design_system/loading_overlay.dart';
import 'package:orders_sw/src/core/injection/injections.dart';
import 'package:orders_sw/src/core/route/route_path.dart';
import 'package:orders_sw/src/core/utils/utils.dart';
import 'package:orders_sw/src/features/order/presentation/viewmodels/order_provider.dart';
import 'package:orders_sw/src/features/order/presentation/viewmodels/order_state.dart';
import 'package:orders_sw/src/features/order/presentation/widgets/empty_orders.dart';
import 'package:orders_sw/src/features/order/presentation/widgets/order_error.dart';
import 'package:orders_sw/src/features/order/presentation/widgets/order_list_item.dart';
import 'package:provider/provider.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<OrderProvider>()..init(),
      child: const OrdersViewContent(),
    );
  }
}

class OrdersViewContent extends StatefulWidget {
  const OrdersViewContent({super.key});

  @override
  State<OrdersViewContent> createState() => _OrdersViewContentState();
}

class _OrdersViewContentState extends State<OrdersViewContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.orders),
      ),
      body: Selector<OrderProvider, OrderState>(
        selector: (context, provider) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (provider.state.status == OrderStatus.loading) {
              SWLoading().show(context);
            } else if (provider.state.status == OrderStatus.error) {
              showSnackBarError(context, AppConstants.generalError);
              SWLoading().hide();
            } else {
              SWLoading().hide();
            }
          });

          return provider.state;
        },
        builder: (context, state, child) {
          if (state.status == OrderStatus.error) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<OrderProvider>().init();
              },
              child: OrderError(
                onPressed: () => context.read<OrderProvider>().init(),
              ),
            );
          } else if (state.status == OrderStatus.empty) {
            return EmptyOrders(
              onPressed: () => context.go(RoutePath.orderCreate),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<OrderProvider>().init();
            },
            child: ListView.builder(
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  return OrderListItem(order: state.orders[index]);
                }),
          );
        },
      ),
    );
  }
}
