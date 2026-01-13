class StorageException implements Exception {
  final String message;
  final dynamic originalError;

  StorageException(this.message, {this.originalError});

  @override
  String toString() => 'StorageException: $message${originalError != null ? ' (${originalError.toString()})' : ''}';
}
