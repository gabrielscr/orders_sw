import 'package:flutter/material.dart';
import 'package:orders_sw/src/core/constants/app_constants.dart';
import 'package:orders_sw/src/core/design_system/loading_overlay.dart';
import 'package:orders_sw/src/core/injection/injections.dart';
import 'package:orders_sw/src/core/utils/utils.dart';
import 'package:orders_sw/src/features/order/presentation/viewmodels/order_provider.dart';
import 'package:orders_sw/src/features/order/presentation/viewmodels/order_state.dart';
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
        title: const Text('Orders'),
      ),
      body: Selector<OrderProvider, OrderState>(
        selector: (context, provider) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (provider.state.status == OrderStatus.loading) {
              SWLoading().show(context);
            } else if (provider.state.status == OrderStatus.error) {
              showSnackBarError(context, AppConstants.generalError);
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
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 100, color: Colors.red),
                      const SizedBox(height: 30),
                      const Text(AppConstants.errorWhenLoadingOrders),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<OrderProvider>().init();
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1),
                              ),
                              backgroundColor: Colors.black),
                          child: const Text(AppConstants.tryAgain, style: TextStyle(color: Colors.white, letterSpacing: 2)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return const Center(
            child: Text('orders'),
          );
        },
      ),
    );
  }
}
