part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class GetUsersRequest extends UserEvent {
  GetUsersRequest();
}

class GetLoginRequest extends UserEvent {
  final String id;

  GetLoginRequest(this.id);
}