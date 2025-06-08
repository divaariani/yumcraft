import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:recipes/model/user_model.dart';
import 'package:recipes/utils/app_constant.dart';

class UserController {
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

  //START: List Users
  Future<List<UserModel>> getUsers() async {
    try {
      response = await dio.get(
        "$baseUrl/users",
      );

      List<UserModel> result = (response.data as List)
          .map((e) => UserModel.fromJson(e))
          .toList();

      debugPrint("$result nya");
      return result;
    } on DioException catch (e) {
      debugPrint("DioException users: ${e.message}");
      debugPrint("Status CODE users: ${e.response?.statusCode}");
      if (e.type == DioExceptionType.badResponse) {
        int? statusCode = e.response!.statusCode;
        if (statusCode == 404) {
          throw "Data tidak ditemukan";
        }
        throw "error";
      }
      throw "error";
    }
  }
  //END: List Users

  //START: Login by ID
  Future<UserModel> getUserById(String id) async {
    try {
      response = await dio.get(
        "$baseUrl/users/$id",
      );

      UserModel result = UserModel.fromJson(response.data);
      return result;
    } on DioException catch (e) {
      debugPrint("DioException user by ID: ${e.message}");
      debugPrint("Status CODE user by ID: ${e.response?.statusCode}");
      if (e.type == DioExceptionType.badResponse) {
        int? statusCode = e.response!.statusCode;
        if (statusCode == 404) {
          throw "Data tidak ditemukan";
        }
        throw "error";
      }
      throw "error";
    }
  }
  //END: Login by ID
}
