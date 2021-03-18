class ServiceException implements Exception {
  final String message;
  final int statusCode;
  final String reason;
  ServiceException(this.message, this.statusCode, this.reason);

  String toString() {
    if (message != null) {
      return '$message [$statusCode - $reason]';
    }
    return '$statusCode - $reason';
  }
}
