import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes/controller/user_controller.dart';
import 'package:recipes/model/user_model.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<GetUsersRequest>((event, emit) async {
      await _getUsers(event, emit);
    });
    on<GetLoginRequest>((event, emit) async {
      await _getUserById(event, emit);
    });
  }

  List<UserModel>? listUsers;
  UserModel? userData;

  Future<void> _getUsers(GetUsersRequest event, Emitter<UserState> emit) async {
    UserController controller = UserController();
    emit(GetUsersLoading());
    try {
      List<UserModel> data = await controller.getUsers();
      listUsers = data;
      emit(GetUsersSuccess());
    } catch (ex) {
      emit(GetUsersError(errorMessage: ex.toString()));
    }
  }

  Future<void> _getUserById(
      GetLoginRequest event, Emitter<UserState> emit) async {
    UserController controller = UserController();
    emit(GetLoginLoading());
    try {
      UserModel data = await controller.getUserById(event.id);
      userData = data;
      emit(GetLoginSuccess());
    } catch (ex) {
      emit(GetLoginError(errorMessage: ex.toString()));
    }
  }
}
