import 'package:dio/dio.dart';
import 'package:recipes/model/user_model.dart';
import 'package:recipes/utils/app_constant.dart';

class RegisterController {
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

  //Start: Post Register
  Future<UserModel> register(UserModel viewModel) async {
    try {
      response = await dio.post(
        "$baseUrl/users",
        data: viewModel.toJson(),
      );
      var data = UserModel.fromJson(response.data);
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
  //END: Post Register
}
