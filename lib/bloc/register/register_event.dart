part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent {}

class PostRegisterRequest extends RegisterEvent {
  final UserModel? viewModel;
  PostRegisterRequest({this.viewModel});
}
