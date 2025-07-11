import 'package:dio/dio.dart';
import 'package:try_app/src/core/errors/failure.dart';

Failure handleDioError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return TimeoutFailure("Connection timed out. Please check your internet.");

    case DioExceptionType.sendTimeout:
      return TimeoutFailure("Send timeout. Please try again.");

    case DioExceptionType.receiveTimeout:
      return TimeoutFailure("Receiving response took too long. Try again.");

    case DioExceptionType.badCertificate:
      return CertificateFailure("SSL Certificate verification failed.");

    case DioExceptionType.badResponse:
      final statusCode = error.response?.statusCode;
      final responseData = error.response?.data;
      // print("response data is $responseData ${statusCode}");
      switch (statusCode) {
        case 400:
          return ValidationFailure("Invalid request. ${_extractMessage(responseData)}");
        case 401:
          return UnauthorizedFailure("Unauthorized. Please log in again.");
        case 403:
          return ForbiddenFailure("Access forbidden. You don't have permission.");
        case 404:
          return NotFoundFailure("Resource not found.");
        case 409:
          return ConflictFailure("Conflict occurred. ${_extractMessage(responseData)}");
        case 422:
          return ValidationFailure("Unprocessable entity. ${_extractMessage(responseData)}");
        case 500:
          return ServerFailure("Internal server error.");
        default:
          return ServerFailure("Unexpected server error. Code: $statusCode");
      }

    case DioExceptionType.cancel:
      return CancelledFailure("Request was cancelled.");

    case DioExceptionType.connectionError:
      return NetworkFailure("Connection failed. Please check your internet.");

    case DioExceptionType.unknown:
    default:
      return UnknownFailure("An unknown error occurred: ${error.message}");
  }
}

String _extractMessage(dynamic data) {
  if (data is Map<String, dynamic> && data.containsKey('message')) {
    return data['message'];
  }
  return "";
}
