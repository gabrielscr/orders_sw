import 'package:flutter/material.dart';
import 'package:orders_sw/src/core/route/base_routes.dart';
import 'package:orders_sw/src/core/route/navigation_actions.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Auth View'),
            ElevatedButton(
              onPressed: () => NavigationAction.of(context).navigate(BaseRoutes.order),
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
