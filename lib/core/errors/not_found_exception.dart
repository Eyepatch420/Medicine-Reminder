class NotFoundException implements Exception {
  final String message;
  final String id;

  NotFoundException(this.message, this.id);

  @override
  String toString() => 'NotFoundException: $message (ID: $id)';
}
