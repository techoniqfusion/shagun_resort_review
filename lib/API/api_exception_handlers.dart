import 'dart:async';
import 'dart:io';

class ExceptionHandlers {
  getException(exception) {
    if (exception is SocketException) {
      return 'No internet connection.';
    } else if (exception is HttpException) {
      return 'HTTP error occurred.';
    } else if (exception is FormatException) {
      return 'Invalid data format.';
    } else if (exception is TimeoutException) {
      return 'Request timeout.';
    } else if (exception is BadRequestException) {
      return exception.message.toString();
    } else if (exception is UnAuthorizedException) {
      return exception.message.toString();
    } else if (exception is NotFoundException) {
      return exception.message.toString();
    } else if (exception is FetchDataException) {
      return exception.message.toString();
    } else {
      return 'Something went wrong';
    }
  }
}

class AppException implements Exception{
  final String? message;
  final String? prefix;
  final String? url;

  AppException([this.message, this.prefix, this.url]);
}

class BadRequestException extends AppException{
  BadRequestException([String? message, String? url])
      : super(message, 'Bad request', url);
}

class FetchDataException extends AppException {
  FetchDataException([String? message, String? url])
      : super(message, 'Unable to process the request', url);
}

class ApiNotRespondingException extends AppException {
  ApiNotRespondingException([String? message, String? url])
      : super(message, 'Api not responding', url);
}

class UnAuthorizedException extends AppException {
  UnAuthorizedException([String? message, String? url])
      : super(message, 'Unauthorized request', url);
}

class NotFoundException extends AppException {
  NotFoundException([String? message, String? url])
      : super(message, 'Page not found', url);
}