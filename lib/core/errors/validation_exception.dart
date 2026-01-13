class ValidationException implements Exception {
  final String message;
  final String? field;

  ValidationException(this.message, {this.field});

  @override
  String toString() => field != null ? '$field: $message' : message;
}
