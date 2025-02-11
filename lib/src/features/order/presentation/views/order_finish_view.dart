import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orders_sw/src/core/constants/app_constants.dart';
import 'package:orders_sw/src/core/route/route_path.dart';
import 'package:orders_sw/src/core/utils/extensions.dart';
import 'package:orders_sw/src/features/order/domain/entities/order_entity.dart';

class OrderFinishView extends StatelessWidget {
  final OrderEntity order;

  const OrderFinishView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  const Center(
                    child: Icon(
                      Icons.check_circle,
                      size: 100,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Pedido finalizado com sucesso!',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  Text(order.description, style: const TextStyle(fontSize: 15)),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('Cliente:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 5),
                      Text(order.customerName),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('Data do pedido:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 5),
                      Text(order.createdAt.formatDateToBrazilian()),
                    ],
                  ),
                ],
              ),
            ),
            ...[
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
                  onPressed: () => context.pushReplacement(RoutePath.orders),
                  child: const Text(
                    AppConstants.backToOrders,
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
      ),
    );
  }
}
