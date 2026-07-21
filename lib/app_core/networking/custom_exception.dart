class CustomException implements Exception {
  final _message;
  final _prefix;
  final dynamic error;

  CustomException([this._message, this._prefix, this.error = '']);

  @override
  String toString() {
    return '$_prefix$_message';
  }
}

class FetchDataException extends CustomException {
  FetchDataException([String? message])
    : super(message, 'Error During Communication: ');
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, 'Invalid Request: ');
}

class UnauthorizedException extends CustomException {
  UnauthorizedException([message]) : super(message, 'Unauthorized: ');
}

class InvalidInputException extends CustomException {
  InvalidInputException([String? message]) : super(message, 'Invalid Input: ');
}
