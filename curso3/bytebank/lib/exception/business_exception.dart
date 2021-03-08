class BusinessException implements Exception {
  final String message;
  BusinessException(this.message);

  String toString() {
    String message = this.message;
    if (message == null || message.length == 0) {
      return "BusinessException";
    }
    return this.message;
  }
}
