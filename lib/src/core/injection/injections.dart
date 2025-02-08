import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:orders_sw/external/services/secure_storage/secure_storage.dart';
import 'package:orders_sw/external/services/secure_storage/secure_storage_impl.dart';
import 'package:orders_sw/external/services/storage/storage_service.dart';
import 'package:orders_sw/external/services/storage/storage_service_impl.dart';
import 'package:orders_sw/src/core/constants/constants.dart';
import 'package:orders_sw/src/core/external/network/http_service.dart';
import 'package:orders_sw/src/core/external/network/http_service_impl.dart';
import 'package:orders_sw/src/core/external/network/logging_interceptor.dart';
import 'package:orders_sw/src/core/external/network/token_interceptor.dart';
import 'package:orders_sw/src/features/auth/domain/services/auth_service.dart';

final getIt = GetIt.instance;

abstract class Injection {
  Future<void> inject(GetIt getIt);
}

class ConfigInjection implements Injection {
  @override
  Future<void> inject(GetIt getIt) async {
    await _defaultInjections();

    await getIt.allReady();
  }

  static Future<void> _defaultInjections() async {
    getIt.registerSingleton<SecureStorage>(SecureStorageImpl(flutterSecureStorage: const FlutterSecureStorage()));
    getIt.registerLazySingleton<StorageService>(() => StorageServiceImpl(secureStorage: getIt<SecureStorage>()));
    getIt.registerLazySingleton<AuthService>(() => AuthServiceImpl(storageService: getIt<StorageService>()));
    getIt.registerLazySingleton<LoggingInterceptor>(() => LoggingInterceptor());
    getIt.registerLazySingleton<TokenInterceptor>(() => TokenInterceptor(authService: getIt<AuthService>()));
    getIt.registerLazySingleton<HttpService>(() => HttpServiceImpl(_dioConfig));
  }

  static Dio get _dioConfig => Dio(
        BaseOptions(
          baseUrl: Constants.baseUrl,
          headers: {
            HttpHeaders.acceptHeader: ContentType.json.value,
            HttpHeaders.contentTypeHeader: ContentType.json.value,
          },
        ),
      )..interceptors.addAll(
          {
            getIt<LoggingInterceptor>(),
            getIt<TokenInterceptor>(),
          },
        );
}
