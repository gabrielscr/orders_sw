import 'package:flutter/material.dart';
import 'package:orders_sw/src/core/constants/constants.dart';
import 'package:orders_sw/src/core/route/navigation_delegate.dart';
import 'package:orders_sw/src/core/route/navigation_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: Constants.appName,
      routerDelegate: NavigationDelegate(
        state: NavigationStateImpl(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
