part of 'register_bloc.dart';

@immutable
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

//Start: Post Register
class PostRegisterSuccess extends RegisterState {
  final UserModel? response;
  PostRegisterSuccess(this.response);
}

class PostRegisterError extends RegisterState {
  final String? errorMessage;
  PostRegisterError({this.errorMessage});
}

class PostRegisterWaiting extends RegisterState {}
//End: Post Register
