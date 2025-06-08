part of 'user_bloc.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

//Start: User
class GetUsersSuccess extends UserState {
  GetUsersSuccess();
}

class GetUsersError extends UserState {
  final String? errorMessage;
  GetUsersError({this.errorMessage});
}

class GetUsersLoading extends UserState {}
//End: User

//Start: Login by ID
class GetLoginSuccess extends UserState {
  GetLoginSuccess();
}

class GetLoginError extends UserState {
  final String? errorMessage;
  GetLoginError({this.errorMessage});
}

class GetLoginLoading extends UserState {}
//End: Login by ID