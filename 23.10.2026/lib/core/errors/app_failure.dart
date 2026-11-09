sealed class AppFailure {
  const AppFailure(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() =>
      '$runtimeType: $message${cause != null ? ' ($cause)' : ''}';
}

class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message, [super.cause]);
}

class StorageFailure extends AppFailure {
  const StorageFailure(super.message, [super.cause]);
}

class NotFoundFailure extends AppFailure {
  const NotFoundFailure(super.message, [super.cause]);
}

class ConflictFailure extends AppFailure {
  const ConflictFailure(super.message, [super.cause]);
}

class PermissionFailure extends AppFailure {
  const PermissionFailure(super.message, [super.cause]);
}

class PlatformFailure extends AppFailure {
  const PlatformFailure(super.message, [super.cause]);
}
