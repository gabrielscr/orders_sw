import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:orders_sw/external/services/secure_storage/secure_storage.dart';
import 'package:orders_sw/external/services/storage/storage_exception_handler.dart';
import 'package:orders_sw/external/services/storage/storage_service.dart';
import 'package:orders_sw/src/core/constants/storage_keys.dart';
import 'package:orders_sw/src/core/exception/failure.dart';
import 'package:orders_sw/src/features/auth/data/models/user_model.dart';
import 'package:orders_sw/src/features/auth/data/models/user_token_response_model.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_auth.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_token.dart';

final class StorageServiceImpl implements StorageService {
  final SecureStorage _secureStorage;

  StorageServiceImpl({required SecureStorage secureStorage}) : _secureStorage = secureStorage;

  @override
  Future<Either<Failure, void>> clearUser() async {
    try {
      await _secureStorage.delete(StorageKeys.user);

      return right(null);
    } on Exception catch (e) {
      return e.handleStorageFailure();
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getUser() async {
    try {
      final userFromStorage = await _secureStorage.read('user');

      final user = userFromStorage != null ? UserModel.fromMap(jsonDecode(userFromStorage)).toEntity() : null;

      return right(user);
    } on Exception catch (e) {
      return e.handleStorageFailure();
    }
  }

  @override
  Future<Either<Failure, void>> saveUser(UserEntity user) async {
    try {
      final map = UserModel.fromEntity(user).toMap();

      final userJson = jsonEncode(map);

      await _secureStorage.write(StorageKeys.user, userJson);

      return right(null);
    } on Exception catch (e) {
      return e.handleStorageFailure();
    }
  }

  @override
  Future<Either<Failure, UserTokenEntity?>> getToken() async {
    try {
      final tokenFromStorage = await _secureStorage.read(StorageKeys.token);

      final token = tokenFromStorage != null ? UserTokenResponseModel.fromMap(jsonDecode(tokenFromStorage)) : null;

      return right(token);
    } on Exception catch (e) {
      return e.handleStorageFailure();
    }
  }

  @override
  Future<Either<Failure, void>> clearToken() async {
    try {
      await _secureStorage.delete(StorageKeys.token);

      return right(null);
    } on Exception catch (e) {
      return e.handleStorageFailure();
    }
  }

  @override
  Future<Either<Failure, void>> saveRefreshToken(UserTokenEntity entity) async {
    try {
      final token = UserTokenResponseModel.fromEntity(entity);

      final tokenJson = jsonEncode(token.toMap());

      await _secureStorage.write(StorageKeys.token, tokenJson);

      return right(null);
    } on Exception catch (e) {
      return e.handleStorageFailure();
    }
  }

  @override
  Future<Either<Failure, void>> saveToken(UserTokenEntity token) async {
    try {
      final tokenJson = jsonEncode(UserTokenResponseModel.fromEntity(token).toMap());

      await _secureStorage.write(StorageKeys.token, tokenJson);

      return right(null);
    } on Exception catch (e) {
      return e.handleStorageFailure();
    }
  }
}
