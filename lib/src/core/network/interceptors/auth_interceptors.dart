



import 'package:dio/dio.dart';
import 'package:try_app/src/core/services/token_storeage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage tokenStorage;
  final Dio dio;
  bool _isRefreshing = false;
  final List<RequestOptions> _failedRequests = [];


  AuthInterceptor({required this.tokenStorage, required this.dio});
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await tokenStorage.getAccessToken();
    if (accessToken != null && !_isLoginOrRefreshEndpoint(options.path)) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    return handler.next(options);
  }

  @override 
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !_isLoginOrRefreshEndpoint(err.requestOptions.path)) {
      // Prevent multiple simultaneous refresh attempts
      if (_isRefreshing) {
        _failedRequests.add(err.requestOptions);
        return; // Don't call handler.next() here
      }

      _isRefreshing = true;

      try {
        final newAccessToken = await _refreshAccessToken();
        if (newAccessToken != null) {
          // Retry original request with new token
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newAccessToken';

          // Retry all failed requests
          for (final request in _failedRequests) {
            request.headers['Authorization'] = 'Bearer $newAccessToken';
            try {
              await dio.fetch(request);
            } catch (e) {
              // Handle individual request failures
            }
          }
          _failedRequests.clear();

          final clonedRequest = await dio.fetch(options);
          return handler.resolve(clonedRequest);
        } else {
          // Token refresh failed, clear tokens and logout user
          await tokenStorage.clearTokens();
          return handler.next(err);
        }
      } catch (refreshError) {
        // Token refresh failed, clear tokens
        await tokenStorage.clearTokens();
        return handler.next(err);
      } finally {
        _isRefreshing = false;
      }
    }
    return handler.next(err);
  }

  bool _isLoginOrRefreshEndpoint(String path) {
    return path.contains("/login") || 
           path.contains("/refresh") || 
           path.contains("/register") ||
           path.contains("/auth/");
  }

  Future<String?> _refreshAccessToken() async {
    try {
      final refreshToken = await tokenStorage.getRefreshToken();
      if (refreshToken == null) {
        return null;
      }

      // Create a separate dio instance for token refresh to avoid interceptor loops
      final refreshDio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
        },
      ));

      final response = await refreshDio.post(
        'https://gharchaiyo.com/api/v1/account/refresh/',
        data: {"refresh": refreshToken},
      );

      if (response.statusCode == 200 && response.data != null) {
        final accessToken = response.data["access"];
        final newRefreshToken = response.data["refresh"];

        if (accessToken != null) {
          await tokenStorage.saveTokens(accessToken, newRefreshToken ?? refreshToken);
          return accessToken;
        }
      }
      return null;
    } catch (e) {
      print('Token refresh failed: $e');
      return null;
    }
  }
}