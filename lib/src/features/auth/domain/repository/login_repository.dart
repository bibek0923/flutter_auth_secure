import 'package:dartz/dartz.dart';
import 'package:try_app/src/core/errors/failure.dart';
import 'package:try_app/src/features/auth/data/models/login_request_model.dart';
import 'package:try_app/src/features/auth/domain/entity/login_response_entity.dart';

abstract class LoginRepository {
Future<Either<Failure,LoginEntity>> login({required LoginRequest loginParams});
}