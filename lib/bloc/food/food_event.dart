part of 'food_bloc.dart';

@immutable
abstract class FoodEvent {}

class PostRecipeRequest extends FoodEvent {
  final FoodModel? viewModel;
  PostRecipeRequest({this.viewModel});
}
