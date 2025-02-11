import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:orders_sw/src/core/constants/app_constants.dart';
import 'package:orders_sw/src/core/design_system/custom_text_form_field.dart';
import 'package:orders_sw/src/core/injection/injections.dart';
import 'package:orders_sw/src/features/auth/presentation/provider/auth_provider.dart';
import 'package:orders_sw/src/features/auth/presentation/provider/auth_state.dart';
import 'package:orders_sw/src/features/auth/presentation/views/auth_view.dart';
import 'package:provider/provider.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late MockAuthProvider mockAuthProvider;

  setUp(() {
    mockAuthProvider = MockAuthProvider();
    getIt.registerLazySingleton<AuthProvider>(() => mockAuthProvider);

    registerFallbackValue(RouteFake());
  });

  tearDown(() {
    getIt.unregister<AuthProvider>();
  });

  void updateState({required AuthState state}) {
    when(() => mockAuthProvider.state).thenReturn(state);
  }

  Future<void> buildView(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (context) => getIt<AuthProvider>(),
          child: const AuthView(),
        ),
      ),
    );
  }

  testWidgets('Should build page', (WidgetTester tester) async {
    updateState(state: AuthState.initial());

    await buildView(tester);

    await tester.pumpAndSettle();

    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(Form), findsOneWidget);
    expect(find.byType(SWTextFormField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('Should show error', (WidgetTester tester) async {
    updateState(state: AuthState.userError());

    await buildView(tester);

    await tester.pumpAndSettle();

    expect(find.text(AppConstants.userInvalid), findsOneWidget);
  });

  testWidgets('Should show general error', (WidgetTester tester) async {
    updateState(state: AuthState.generalError());

    await buildView(tester);

    await tester.pumpAndSettle();

    expect(find.text(AppConstants.generalError), findsOneWidget);
  });

  testWidgets('Should fill fields and call login', (WidgetTester tester) async {
    updateState(state: AuthState.initial());

    await buildView(tester);

    await tester.pumpAndSettle();

    final userNameField = find.byWidgetPredicate((widget) => widget is SWTextFormField && widget.label == AppConstants.user);
    final passwordField = find.byWidgetPredicate((widget) => widget is SWTextFormField && widget.label == AppConstants.password);
    final loginButton = find.byType(ElevatedButton);

    await tester.enterText(userNameField, 'user');
    await tester.enterText(passwordField, 'password');

    await tester.tap(loginButton);
  });
}
