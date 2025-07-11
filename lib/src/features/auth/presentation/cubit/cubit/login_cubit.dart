import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:try_app/src/core/services/token_storeage.dart';
import 'package:try_app/src/features/auth/data/models/login_request_model.dart';
import 'package:try_app/src/features/auth/domain/entity/login_response_entity.dart';
import 'package:try_app/src/features/auth/domain/usecases/login_usecase.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.loginUsecase, this.tokenStorage) : super(LoginInitial());
  final LoginUsecase loginUsecase;
  final TokenStorage tokenStorage;
  //using try catch traditional approcah
  // Future<void> login(String username , String password)async {
  //   emit(LoginLoading());
  //   try {

  //   //  final result = await loginUsecase.call(LoginRequest(username: username, password: password)); is same as
  //   final result = await loginUsecase(LoginRequest(username: username, password: password));
  //   //  return result;

  //   print("result is ${result.user.username}");
  //   emit(LoginSuccess( result));

  //   } catch (e) {
  //     if( e is Failure ){
  //       emit (LoginFailure(message: e.message)) ;
  //     }
  //     else {
  //       emit(LoginFailure(message: "unexpected error occured"));
  //     }
  //   }
  // }

  // using EitherOR approach
  Future<void> login(String username, String password) async {
    emit(LoginLoading());
    final result = await loginUsecase.call(
      LoginRequest(username: username, password: password),
    );
    result.fold(
      (failure) {
        emit(LoginFailure(message: failure.message));
      },
      (entity) {
        // TokenStorage().saveTokens(entity.accessToken, entity.refreshToken);
        tokenStorage.saveTokens(entity.accessToken, entity.refreshToken);
        
        emit(LoginSuccess(entity));
      },
    );
  }
}
