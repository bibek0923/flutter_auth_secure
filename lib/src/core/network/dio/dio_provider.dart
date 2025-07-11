import 'package:dio/dio.dart';
import 'package:try_app/src/core/network/interceptors/auth_interceptors.dart';

import 'package:try_app/src/core/services/token_storeage.dart';


Dio createDioClient() {
  final dio = Dio(BaseOptions(
    
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    baseUrl: dotenv.env['baseUrl'].toString(),
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  final tokenStorage = TokenStorage();
  dio.interceptors.add(AuthInterceptor(tokenStorage: tokenStorage, dio: dio));

  return dio;
}
