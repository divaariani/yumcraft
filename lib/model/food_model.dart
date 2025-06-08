class FoodModel {
  final String? id;
  final String? foodName;
  final String? foodImage;
  final String? foodCategory;
  final String? foodIngredients;
  final String? foodSteps;
  final bool? foodWishlist;
  final int? foodTimer;
  final String? userId;

  FoodModel({
    this.id,
    this.foodName,
    this.foodImage,
    this.foodCategory,
    this.foodIngredients,
    this.foodSteps,
    this.foodWishlist,
    this.foodTimer,
    this.userId,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'] as String?,
      foodName: json['food_name'] as String?,
      foodImage: json['food_image'] as String?,
      foodCategory: json['food_category'] as String?,
      foodIngredients: json['food_ingredients'] as String?,
      foodSteps: json['food_steps'] as String?,
      foodWishlist: json['food_wishlist'] as bool?,
      foodTimer: json['food_timer'] as int?,
      userId: json['user_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'food_name': foodName,
      'food_image': foodImage,
      'food_category': foodCategory,
      'food_ingredients': foodIngredients,
      'food_steps': foodSteps,
      'food_wishlist': foodWishlist,
      'food_timer': foodTimer,
      'user_id': userId,
    };
  }
}
