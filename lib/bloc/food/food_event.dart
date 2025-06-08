part of 'food_bloc.dart';

@immutable
abstract class FoodEvent {}

class PostRecipeRequest extends FoodEvent {
  final FoodModel? viewModel;
  PostRecipeRequest({this.viewModel});
}

class GetRecipesRequest extends FoodEvent {
  final String category;
  final String id;
  GetRecipesRequest({required this.category, required this.id});
}
