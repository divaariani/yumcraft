import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes/controller/register_controller.dart';
import 'package:recipes/model/user_model.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<PostRegisterRequest>((event, emit) async {
      await _postRegister(event.viewModel!, emit);
    });
  }

  Future<void> _postRegister(UserModel viewModel,
      Emitter<RegisterState> emit) async {
    RegisterController controller = RegisterController();
    emit(PostRegisterWaiting());
    try {
      UserModel data = await controller.register(viewModel);
      emit(PostRegisterSuccess(data));
    } catch (ex) {
      emit(PostRegisterError(errorMessage: ex.toString()));
    }
  }
}
