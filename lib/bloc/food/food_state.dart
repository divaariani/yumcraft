part of 'food_bloc.dart';

@immutable
abstract class FoodState {}

class FoodInitial extends FoodState {}

//Start: Post Food
class PostRecipeSuccess extends FoodState {
  final FoodModel? response;
  PostRecipeSuccess(this.response);
}

class PostRecipeError extends FoodState {
  final String? errorMessage;
  PostRecipeError({this.errorMessage});
}

class PostRecipeWaiting extends FoodState {}
//End: Post Food

//Start: Get Recipe
class GetRecipesSuccess extends FoodState {
  GetRecipesSuccess();
}

class GetRecipesError extends FoodState {
  final String? errorMessage;
  GetRecipesError({this.errorMessage});
}

class GetRecipesLoading extends FoodState {}
//End: Get Recipe