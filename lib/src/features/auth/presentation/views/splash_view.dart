// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orders_sw/src/core/constants/constants.dart';
import 'package:orders_sw/src/core/route/route_path.dart';
import 'package:orders_sw/src/features/auth/presentation/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF46068E),
      body: Builder(
        builder: (context) {
          final authProvider = context.read<AuthProvider>();

          Future.delayed(const Duration(seconds: 2), () {
            if (authProvider.isAuthenticated) {
              context.pushReplacement(RoutePath.orders);
              return;
            }

            context.pushReplacement(RoutePath.login);
          });

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(Constants.logo),
            ),
          );
        },
      ),
    );
  }
}
