import 'package:flutter/cupertino.dart';

class OrderDetailView extends StatefulWidget {
  final dynamic order;

  const OrderDetailView({super.key, this.order});

  @override
  State<OrderDetailView> createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<OrderDetailView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
