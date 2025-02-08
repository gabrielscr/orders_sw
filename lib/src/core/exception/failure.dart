final class Failure {
  const Failure._();

  factory Failure.general() => const _GeneralFailure();
  factory Failure.storageService() => const _StorageServiceFailure();
  factory Failure.unauthorized() => const _UnauthorizedFailure();
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
