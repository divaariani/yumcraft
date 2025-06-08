import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:recipes/model/food_model.dart';
import 'package:recipes/utils/app_constant.dart';

class FoodController {
  Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(milliseconds: 60000),
      receiveTimeout: const Duration(milliseconds: 60000),
      contentType: "application/json",
      responseType: ResponseType.json,
    ),
  );
  late Response response;

  //Start: Post Food
  Future<FoodModel> createRecipe(FoodModel viewModel) async {
    try {
      response = await dio.post(
        "$baseUrl/foods",
        data: viewModel.toJson(),
      );
      var data = FoodModel.fromJson(response.data);
      return data;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        int? statusCode = e.response!.statusCode;
        if (statusCode == 500) {
          throw "500";
        }
        throw "error";
      }
      throw "error";
    }
  }
  //END: Post Food

  //START: List Recipe per Category
  Future<List<FoodModel>> getRecipes(String category, String id) async {
    try {
      response = await dio.get(
        "$baseUrl/foods?food_category=$category&user_id=$id",
      );

      List<FoodModel> result = (response.data as List)
          .map((e) => FoodModel.fromJson(e))
          .toList();

      debugPrint("$result nya");
      return result;
    } on DioException catch (e) {
      debugPrint("DioException recipes: ${e.message}");
      debugPrint("Status CODE recipes: ${e.response?.statusCode}");
      if (e.type == DioExceptionType.badResponse) {
        int? statusCode = e.response!.statusCode;
        if (statusCode == 404) {
          throw "Data not found";
        }
        throw "error";
      }
      throw "error";
    }
  }
  //END: List Recipe per Category
}
