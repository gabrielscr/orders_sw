import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orders_sw/src/core/constants/app_constants.dart';
import 'package:orders_sw/src/core/design_system/custom_text_form_field.dart';
import 'package:orders_sw/src/core/design_system/loading_overlay.dart';
import 'package:orders_sw/src/core/injection/injections.dart';
import 'package:orders_sw/src/core/route/route_path.dart';
import 'package:orders_sw/src/core/utils/utils.dart';
import 'package:orders_sw/src/features/order/presentation/provider/order_provider.dart';
import 'package:orders_sw/src/features/order/presentation/provider/order_state.dart';
import 'package:provider/provider.dart';

class OrderCreateView extends StatelessWidget {
  const OrderCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<OrderProvider>(),
      child: const OrderCreateViewContent(),
    );
  }
}

class OrderCreateViewContent extends StatefulWidget {
  const OrderCreateViewContent({super.key});

  @override
  State<OrderCreateViewContent> createState() => _OrderCreateViewState();
}

class _OrderCreateViewState extends State<OrderCreateViewContent> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  final FocusNode customerNameFocus = FocusNode();
  final FocusNode descriptionFocus = FocusNode();

  bool _isValidForm = false;

  @override
  void initState() {
    super.initState();

    customerNameFocus.addListener(() {
      if (!customerNameFocus.hasFocus) {
        _formKey.currentState?.validate();
      }
    });

    descriptionFocus.addListener(() {
      if (!descriptionFocus.hasFocus) {
        _formKey.currentState?.validate();
      }
    });
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _descriptionController.dispose();
    customerNameFocus.dispose();
    descriptionFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.createOrder),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pushReplacement(RoutePath.orders),
        ),
      ),
      body: Selector<OrderProvider, OrderState>(
        selector: (context, provider) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              if (provider.state.status == OrderStatus.loading) {
                SWLoading().show(context);
              } else if (provider.state.status == OrderStatus.created) {
                context.pushReplacement(RoutePath.orders);

                showSnackBarSuccess(context, AppConstants.orderCreated);
                SWLoading().hide();
              } else if (provider.state.status == OrderStatus.createError) {
                showSnackBarError(context, AppConstants.errorWhenCreatingOrder);
                SWLoading().hide();
              } else if (provider.state.status == OrderStatus.error && provider.state.failure!.isUnauthorized) {
                showSnackBarError(context, AppConstants.expiredSession);
                SWLoading().hide();
              } else {
                SWLoading().hide();
              }
            },
          );

          return provider.state;
        },
        builder: (context, state, child) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Expanded(
                    child: ListView(
                      children: [
                        SWTextFormField(
                          label: AppConstants.customerName,
                          focusNode: customerNameFocus,
                          controller: _customerNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppConstants.requiredField;
                            }
                            return null;
                          },
                          onChanged: (_) {
                            orderProvider.resetState();

                            setState(() {
                              _isValidForm = _formKey.currentState!.validate();
                            });

                            return;
                          },
                        ),
                        const SizedBox(height: 10),
                        SWTextFormField(
                          focusNode: descriptionFocus,
                          label: AppConstants.description,
                          controller: _descriptionController,
                          maxLines: 2,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppConstants.requiredField;
                            }
                            return null;
                          },
                          onChanged: (_) {
                            orderProvider.resetState();

                            setState(() {
                              _isValidForm = _formKey.currentState!.validate();
                            });

                            return;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                      onPressed: _isValidForm
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                orderProvider.createOrder(
                                  customerName: _customerNameController.text,
                                  description: _descriptionController.text,
                                );
                              }
                            }
                          : null,
                      child: Text(
                        AppConstants.createOrder,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              letterSpacing: 3,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ]
              ],
            ),
          );
        },
      ),
    );
  }
}
