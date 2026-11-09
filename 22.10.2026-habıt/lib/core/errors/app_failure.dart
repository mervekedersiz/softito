class AppFailure implements Exception {
  final String message;
  final dynamic cause;

  const AppFailure(this.message, [this.cause]);

  @override
  String toString() => 'AppFailure: $message ${cause != null ? '($cause)' : ''}';
}

class NotFoundFailure extends AppFailure {
  const NotFoundFailure(super.message, [super.cause]);
}

class StorageFailure extends AppFailure {
  const StorageFailure(super.message, [super.cause]);
}

class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message, [super.cause]);
}
