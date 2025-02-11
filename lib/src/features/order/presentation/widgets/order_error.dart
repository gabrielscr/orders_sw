import 'package:flutter/material.dart';
import 'package:orders_sw/src/core/constants/app_constants.dart';

class OrderError extends StatelessWidget {
  final VoidCallback onPressed;

  const OrderError({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
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
                onPressed: onPressed,
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
    );
  }
}
