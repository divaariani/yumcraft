import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes/controller/Food_controller.dart';
import 'package:recipes/model/food_model.dart';

part 'food_event.dart';
part 'food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  FoodBloc() : super(FoodInitial()) {
    on<PostRecipeRequest>((event, emit) async {
      await _postRecipe(event.viewModel!, emit);
    });
    on<GetRecipesRequest>((event, emit) async {
      await _getRecipes(event, emit);
    });
  }

  Future<void> _postRecipe(FoodModel viewModel,
      Emitter<FoodState> emit) async {
    FoodController controller = FoodController();
    emit(PostRecipeWaiting());
    try {
      FoodModel data = await controller.createRecipe(viewModel);
      emit(PostRecipeSuccess(data));
    } catch (ex) {
      emit(PostRecipeError(errorMessage: ex.toString()));
    }
  }

  List<FoodModel>? listRecipes;

  Future<void> _getRecipes(GetRecipesRequest event, Emitter<FoodState> emit) async {
    FoodController controller = FoodController();
    emit(GetRecipesLoading());
    try {
      List<FoodModel> data = await controller.getRecipes(event.category, event.id);
      listRecipes = data;
      emit(GetRecipesSuccess());
    } catch (ex) {
      emit(GetRecipesError(errorMessage: ex.toString()));
    }
  }
}
