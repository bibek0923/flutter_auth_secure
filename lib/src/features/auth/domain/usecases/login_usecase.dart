import 'package:dartz/dartz.dart';
import 'package:try_app/src/core/errors/failure.dart';
import 'package:try_app/src/features/auth/data/models/login_request_model.dart';
import 'package:try_app/src/features/auth/domain/entity/login_response_entity.dart';
import 'package:try_app/src/features/auth/domain/repository/login_repository.dart';

class LoginUsecase {
  final LoginRepository repository;

  // LoginUsecase(Object object, {required this.repository});
  LoginUsecase(this.repository);

  Future <Either<Failure,LoginEntity>> call (LoginRequest request){
    return repository.login(loginParams: request);
  }

}
