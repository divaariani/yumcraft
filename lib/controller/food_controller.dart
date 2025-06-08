import 'package:dio/dio.dart';
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
      throw "errorKoneksi";
    }
  }
  //END: Post Food
}
