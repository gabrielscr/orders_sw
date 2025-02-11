import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orders_sw/src/core/constants/app_constants.dart';
import 'package:orders_sw/src/core/constants/constants.dart';
import 'package:orders_sw/src/core/design_system/custom_text_form_field.dart';
import 'package:orders_sw/src/core/design_system/loading_overlay.dart';
import 'package:orders_sw/src/core/route/route_path.dart';
import 'package:orders_sw/src/core/utils/utils.dart';
import 'package:orders_sw/src/features/auth/presentation/provider/auth_provider.dart';
import 'package:orders_sw/src/features/auth/presentation/provider/auth_state.dart';
import 'package:provider/provider.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _userNameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool _isValidForm = false;

  @override
  void initState() {
    super.initState();

    _userNameFocus.addListener(() {
      if (!_userNameFocus.hasFocus) {
        _formKey.currentState?.validate();
      }
    });

    _passwordFocus.addListener(() {
      if (!_passwordFocus.hasFocus) {
        _formKey.currentState?.validate();
      }
    });
  }

  @override
  dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    _userNameFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Selector<AuthProvider, AuthState>(
      selector: (context, provider) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (provider.state == AuthState.loading()) {
            SWLoading().show(context);
          } else if (provider.state == AuthState.authenticated()) {
            context.pushReplacement(RoutePath.orders);
          } else if (provider.state == AuthState.userError()) {
            showSnackBarError(context, AppConstants.userInvalid);
          } else if (provider.state == AuthState.generalError()) {
            showSnackBarError(context, AppConstants.generalError);
          }
        });

        SWLoading().hide();

        return provider.state;
      },
      builder: (context, state, child) => Scaffold(
        backgroundColor: const Color(0xFF46068E),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).padding.top,
                  ),
                  Image.asset(
                    Constants.logo,
                    width: 200,
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    AppConstants.welcome,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    AppConstants.loginToContinue,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(height: 20),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            SWTextFormField(
                              controller: _userNameController,
                              focusNode: _userNameFocus,
                              label: AppConstants.user,
                              obscureText: false,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppConstants.requiredField;
                                }
                                return null;
                              },
                              onChanged: (_) {
                                authProvider.resetState();

                                setState(() {
                                  _isValidForm = _formKey.currentState!.validate();
                                });

                                return;
                              },
                            ),
                            const SizedBox(height: 10),
                            SWTextFormField(
                              controller: _passwordController,
                              focusNode: _passwordFocus,
                              label: AppConstants.password,
                              obscureText: true,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppConstants.requiredField;
                                }
                                return null;
                              },
                              onChanged: (_) {
                                authProvider.resetState();

                                setState(() {
                                  _isValidForm = _formKey.currentState!.validate();
                                });

                                return;
                              },
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: Consumer(
                                builder: (context, watch, child) {
                                  return ElevatedButton(
                                    onPressed: _isValidForm
                                        ? () {
                                            if (_formKey.currentState!.validate()) {
                                              authProvider.generateToken(username: _userNameController.text, password: _passwordController.text);
                                            }
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(1),
                                        ),
                                        backgroundColor: Colors.black),
                                    child: Text(
                                      AppConstants.enter,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            letterSpacing: 3,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
