part of 'login_cubit.dart';

@immutable
sealed class LoginState {}
sealed class LoginActionState extends LoginState{}

final class LoginInitial extends LoginState {}
final class LoginSuccess extends LoginActionState{
  final LoginEntity entity;
  LoginSuccess(this.entity);
}
final class LoginLoading extends LoginState{

}
final class LoginFailure extends LoginActionState{
  final String message;
  LoginFailure({required this.message});
}