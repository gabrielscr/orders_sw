final class Failure {
  const Failure._();

  factory Failure.general() => const _GeneralFailure();
  factory Failure.storageService() => const _StorageServiceFailure();
  factory Failure.unauthorized() => const _UnauthorizedFailure();
  factory Failure.forbidden() => const _ForbiddenFailure();
  factory Failure.badRequest() => const _BadRequestFailure();

  bool get isGeneral => this is _GeneralFailure;
  bool get isStorageService => this is _StorageServiceFailure;
  bool get isUnauthorized => this is _UnauthorizedFailure;
  bool get isForbidden => this is _ForbiddenFailure;
  bool get isBadRequest => this is _BadRequestFailure;
}

final class _GeneralFailure extends Failure {
  const _GeneralFailure() : super._();
}

final class _StorageServiceFailure extends Failure {
  const _StorageServiceFailure() : super._();
}

final class _UnauthorizedFailure extends Failure {
  const _UnauthorizedFailure() : super._();
}

final class _ForbiddenFailure extends Failure {
  const _ForbiddenFailure() : super._();
}

final class _BadRequestFailure extends Failure {
  const _BadRequestFailure() : super._();
}
