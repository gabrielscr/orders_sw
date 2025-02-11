// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orders_sw/src/core/constants/constants.dart';
import 'package:orders_sw/src/core/route/route_path.dart';
import 'package:orders_sw/src/features/auth/presentation/provider/auth_provider.dart';
import 'package:orders_sw/src/features/auth/presentation/provider/auth_state.dart';
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
      body: Selector<AuthProvider, AuthState>(
        selector: (context, provider) => provider.state,
        builder: (context, state, child) {
          Future.delayed(const Duration(seconds: 2), () {
            if (state.status == AuthStatus.authenticated) {
              context.pushReplacement(RoutePath.orders);
            } else {
              context.go(RoutePath.login);
            }
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
