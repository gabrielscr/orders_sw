import 'package:flutter/material.dart';
import 'package:orders_sw/src/core/route/navigation_route.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> with OnPopNavigation, OnPopOSBackButtonNavigation {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
     
      ),
      body: Center(
        child: Text('Orders View'),
      ),
    );
  }

  @override
  bool onBackButton() {
    return false;
  }

  @override
  void onPop(params, BuildContext context) {
    return;
  }
}
