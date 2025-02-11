import 'package:flutter/material.dart';
import 'package:orders_sw/src/core/constants/app_constants.dart';

class EmptyOrders extends StatelessWidget {
  final VoidCallback onPressed;

  const EmptyOrders({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.remove_shopping_cart_sharp, size: 100, color: Colors.black),
          const SizedBox(height: 30),
          const Text(AppConstants.emptyOrders, style: TextStyle(color: Colors.black, fontSize: 20)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1),
                ),
                backgroundColor: Colors.black,
              ),
              child: const Text(AppConstants.createOrder, style: TextStyle(color: Colors.white, letterSpacing: 2)),
            ),
          ),
        ],
      ),
    );
  }
}
