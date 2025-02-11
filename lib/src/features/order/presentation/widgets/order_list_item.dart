import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orders_sw/src/core/route/route_path.dart';
import 'package:orders_sw/src/core/utils/extensions.dart';
import 'package:orders_sw/src/features/order/domain/entities/order_entity.dart';

class OrderListItem extends StatelessWidget {
  final OrderEntity order;

  const OrderListItem({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        tileColor: Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          order.description,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        ),
        subtitle: Text(order.customerName),
        trailing: Text(order.createdAt.formatDateToBrazilian()),
        leading: Icon(
          order.finished ? Icons.check_circle : Icons.pending,
          color: order.finished ? Colors.green : Colors.orange,
        ),
        onTap: () => context.go(
          RoutePath.orderDetail,
          extra: {'order': order},
        ),
      ),
    );
  }
}
