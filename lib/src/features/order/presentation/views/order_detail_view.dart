import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orders_sw/src/core/constants/app_constants.dart';
import 'package:orders_sw/src/core/design_system/loading_overlay.dart';
import 'package:orders_sw/src/core/injection/injections.dart';
import 'package:orders_sw/src/core/route/route_path.dart';
import 'package:orders_sw/src/core/utils/extensions.dart';
import 'package:orders_sw/src/core/utils/utils.dart';
import 'package:orders_sw/src/features/order/domain/entities/order_entity.dart';
import 'package:orders_sw/src/features/order/presentation/provider/order_provider.dart';
import 'package:orders_sw/src/features/order/presentation/provider/order_state.dart';
import 'package:provider/provider.dart';

class OrderDetailView extends StatelessWidget {
  final OrderEntity order;

  const OrderDetailView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<OrderProvider>(),
      child: OrderDetailViewContent(
        order: order,
      ),
    );
  }
}

class OrderDetailViewContent extends StatefulWidget {
  final OrderEntity order;

  const OrderDetailViewContent({super.key, required this.order});

  @override
  State<OrderDetailViewContent> createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<OrderDetailViewContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(AppConstants.orderDetail),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pushReplacement(RoutePath.orders),
        ),
      ),
      body: Selector<OrderProvider, OrderState>(
        selector: (context, provider) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (provider.state.status == OrderStatus.loading) {
              SWLoading().show(context);
            } else if (provider.state.status == OrderStatus.error && provider.state.failure!.isBadRequest) {
              showSnackBarError(context, AppConstants.errorWhenFinishingOrder);
              SWLoading().hide();
            } else if (provider.state.status == OrderStatus.error && provider.state.failure!.isUnauthorized) {
              showSnackBarError(context, AppConstants.expiredSession);
              SWLoading().hide();
            } else if (provider.state.status == OrderStatus.finish) {
              context.pushReplacement(RoutePath.orderFinish, extra: {'order': widget.order});
              SWLoading().hide();
            } else {
              SWLoading().hide();
            }
          });

          return provider.state;
        },
        builder: (context, state, child) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Center(
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          size: 100,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(widget.order.description, style: const TextStyle(fontSize: 15)),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text('Cliente:', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 5),
                          Text(widget.order.customerName),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text('Data de criação:', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 5),
                          Text(widget.order.createdAt.formatDateToBrazilian()),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text('Finalizado:', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 5),
                          Text(widget.order.finished ? 'Sim' : 'Não'),
                        ],
                      ),
                    ],
                  ),
                ),
                if (!widget.order.finished) ...[
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                      onPressed: () => showFinishDialog(),
                      child: const Text(
                        AppConstants.finishOrder,
                        style: TextStyle(
                          letterSpacing: 2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ]
              ],
            ),
          );
        },
      ),
    );
  }

  void showFinishDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text(
            AppConstants.finishOrder,
            style: TextStyle(color: Color(0xFF46068E)),
            textAlign: TextAlign.center,
          ),
          content: const Text(AppConstants.finishOrderMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(AppConstants.cancel),
            ),
            TextButton(
              onPressed: () {
                Provider.of<OrderProvider>(context, listen: false).finishOrder(order: widget.order);
              },
              child: const Text(
                AppConstants.finish,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}
