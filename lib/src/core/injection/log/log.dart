import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Log {
  Log();
  final Level _appLevel = Level.verbose;

  void verbose(
    String message, {
    String? name,
    StackTrace? stackTrace,
    Object? exception,
  }) {
    const level = Level.verbose;
    final show = _appLevel.index <= level.index;
    if (kDebugMode && show) {
      return developer.log(
        _formatMessage(Level.verbose, message),
        name: 'ORDERS_SW: $name',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }

  void debug(
    String message, {
    String name = 'DEBUG',
    StackTrace? stackTrace,
    Object? exception,
  }) {
    const level = Level.debug;
    final show = _appLevel.index <= level.index;

    if (kDebugMode && show) {
      return developer.log(
        _formatMessage(Level.debug, message),
        name: 'ORDERS_SW: $name',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }

  void info(
    String message, {
    String name = 'INFO',
    StackTrace? stackTrace,
    Object? exception,
  }) {
    const level = Level.info;
    final show = _appLevel.index <= level.index;

    if (kDebugMode && show) {
      return developer.log(
        _formatMessage(Level.info, message),
        name: 'ORDERS_SW: $name',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }

  void warning(
    String message, {
    String name = 'WARNING',
    StackTrace? stackTrace,
    Object? exception,
  }) {
    const level = Level.warning;
    final show = _appLevel.index <= level.index;

    if (kDebugMode && show) {
      return developer.log(
        _formatMessage(Level.warning, message),
        name: 'ORDERS_SW: $name',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }

  void error(
    String message, {
    String name = 'ERROR',
    StackTrace? stackTrace,
    Object? exception,
  }) {
    const level = Level.error;
    final show = _appLevel.index <= level.index;
    if (kDebugMode && show) {
      return developer.log(
        _formatMessage(Level.error, message),
        name: 'ORDERS_SW: $name',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }

  String _formatMessage(
    Level level,
    String message,
  ) {
    final emoji = _levelEmojis[level];
    final color = _levelColors[level];

    final time = DateFormat.Hms().format(DateTime.now());

    return '$time $color$emoji$message$_reset';
  }
}

enum Level {
  verbose,
  debug,
  info,
  warning,
  error;

  static Level fromString(String level) {
    switch (level) {
      case 'VERBOSE':
        return Level.verbose;
      case 'DEBUG':
        return Level.debug;
      case 'INFO':
        return Level.info;
      case 'WARNING':
        return Level.warning;
      case 'ERROR':
        return Level.error;
      default:
        return Level.verbose;
    }
  }
}

const _levelEmojis = {
  Level.verbose: '',
  Level.debug: '',
  Level.info: '💡 ',
  Level.warning: '🟨 ',
  Level.error: '⛔ ',
};

const _levelColors = {
  Level.verbose: _white,
  Level.info: _green,
  Level.debug: _blue,
  Level.warning: _yellow,
  Level.error: _red,
};

const _reset = '\x1B[0m';
const _white = '\x1B[37m';
const _red = '\x1B[31m';
const _green = '\x1B[32m';
const _yellow = '\x1B[33m';
const _blue = '\x1B[34m';
