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
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.account_circle, color: Color(0xFF46068E)),
          onPressed: () => context.go(RoutePath.user),
        ),
        title: const Text(AppConstants.orders),
        actions: [
          IconButton(
            icon: const Icon(Icons.info, color: Color(0xFF46068E)),
            onPressed: showInfoDialog,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go(RoutePath.orderCreate),
        backgroundColor: const Color(0xFF46068E),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Selector<OrderProvider, OrderState>(
        selector: (context, provider) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (provider.state.status == OrderStatus.loading) {
              SWLoading().show(context);
            } else if (provider.state.status == OrderStatus.error && provider.state.failure!.isBadRequest) {
              showSnackBarError(context, AppConstants.generalError);
              SWLoading().hide();
            } else if (provider.state.status == OrderStatus.error && provider.state.failure!.isUnauthorized) {
              showSnackBarError(context, AppConstants.expiredSession);
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
                return OrderListItem(
                  order: state.orders[index],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<T?> showInfoDialog<T>() {
    return showDialog<T>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text(
            AppConstants.info,
            style: TextStyle(color: Color(0xFF46068E)),
            textAlign: TextAlign.center,
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppConstants.infoMessage),
              SizedBox(height: 20),
              Text(AppConstants.status, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 5),
                  Text(AppConstants.finishedOrder),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.pending, color: Colors.orange),
                  SizedBox(width: 5),
                  Text(AppConstants.pendingOrder),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.add_box_rounded, color: Color(0xFF46068E)),
                  SizedBox(width: 5),
                  Expanded(child: Text(AppConstants.infoCreateOrder)),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(AppConstants.close),
            ),
          ],
        );
      },
    );
  }
}
