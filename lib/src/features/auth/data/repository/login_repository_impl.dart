// import 'package:try_app/src/features/auth/data/models/login_request_model.dart';
// import 'package:try_app/src/features/auth/domain/entity/login_response_entity.dart';
// import 'package:try_app/src/features/auth/domain/repository/login_repository.dart';

// class LoginRepositoryImpl implements LoginRepository {
//   @override
//   Future<LoginEntity> login({required LoginRequest loginParams}) {
//     // // TODO: implement login
//     // throw UnimplementedError();
//     final response =

//   }

// }

import 'package:dartz/dartz.dart';
import 'package:try_app/src/core/errors/failure.dart';
import 'package:try_app/src/features/auth/data/models/login_request_model.dart';
import 'package:try_app/src/features/auth/data/models/login_response_model.dart';
import 'package:try_app/src/features/auth/data/remote_data_source/login_remote_datasource.dart';
import 'package:try_app/src/features/auth/domain/entity/login_response_entity.dart';
import 'package:try_app/src/features/auth/domain/repository/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDatasource remoteDatasource;
  LoginRepositoryImpl(this.remoteDatasource);

  // Future<Either<Failure,LoginEntity>> login({required LoginRequest loginParams}) async{
  //   final response = await remoteDatasource.login(loginParams);
  //   return response.toEntity();
  // }
  Future<Either<Failure, LoginEntity>> login({
    required LoginRequest loginParams,
  }) async {
    //   try{
    // final response = await remoteDatasource.login(loginParams);
    // return Right(response.toEntity());
    //   }
    //   on Failure catch (e){
    //     return Left(e);
    //   }
    //   catch (_){
    // return left(UnknownFailure("something went wrong"));
    //   }
    //     }
    final response = await remoteDatasource.login(loginParams);
  return  response.fold(
      (failure) =>  Left((failure)),
      (loginResponse) => Right(loginResponse.toEntity()),
    );
    // ✅ Dummy fallback to silence Dart's null safety warning
  // throw Exception("Unreachable");
  }
}
