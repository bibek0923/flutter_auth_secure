// import 'package:try_app/src/features/auth/data/models/login_request_model.dart';
// import 'package:try_app/src/features/auth/data/models/login_response_model.dart';
// import 'package:dio/dio.dart';

// abstract class LoginRemoteDatasource {
//     Future<LoginResponse> login(LoginRequest requestParams);
// }

// class LoginRemoteDatasourceImpl implements LoginRemoteDatasource{
//     final Dio dio;
//     LoginRemoteDatasourceImpl(this.dio);

//      Future<LoginResponse> login(LoginRequest requestParams) async{
//      try {
//         print("${requestParams.password},${requestParams.username}");
//       print("before post");
//       final response = await  dio.post('account/login/',data: requestParams.toJson(),onSendProgress: (count, total) {print(" count is $count and total is $total");}, onReceiveProgress: (count, total) =>print(" count is $count and total is $total") ,);
//       print("after post");
//       print(response.statusCode);
//       print(response.data);
//       return LoginResponse.fromJson(response.data);
//      } catch (e) {
//        print(" error is ${ e.toString()}");
//       throw Exception("Login Failed");

//      }
     
//      }
// }



import 'package:dartz/dartz.dart';
import 'package:try_app/src/core/errors/error_handler.dart';
import 'package:try_app/src/core/errors/failure.dart';
import 'package:try_app/src/features/auth/data/models/login_request_model.dart';
import 'package:try_app/src/features/auth/data/models/login_response_model.dart';
import 'package:dio/dio.dart';

abstract class LoginRemoteDatasource {
    Future<Either<Failure,LoginResponse>> login(LoginRequest requestParams);
}

class LoginRemoteDatasourceImpl implements LoginRemoteDatasource{
    final Dio dio;
    LoginRemoteDatasourceImpl(this.dio);
@override
     Future<Either<Failure,LoginResponse>> login(LoginRequest requestParams) async{
     try {

      final response = await  dio.post('account/login/',data: requestParams.toJson(),onSendProgress: (count, total) {print(" count is $count and total is $total");}, onReceiveProgress: (count, total) =>print(" count is $count and total is $total") ,);
      // final response = await  dio.post('account/login',data: requestParams.toJson(),onSendProgress: (count, total) {print(" count is $count and total is $total");}, onReceiveProgress: (count, total) =>print(" count is $count and total is $total") ,);
    
      final loginResponseModel= LoginResponse.fromJson(response.data);
      return Right(loginResponseModel);
     }
     on DioException catch(e){
      // throw handleDioError(e);
      return Left(handleDioError(e));
     }
     
       catch (e, stackTrace) {
      print("Unknown error in login: $e\n$stackTrace");
      return Left( UnknownFailure("Something went wrong."));
    }
     
     }
}