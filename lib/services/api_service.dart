import 'package:dio/dio.dart';
import '../models/api_model.dart';

class ApiService {
  static final Dio dio = Dio();

  static Future<List<ApiModel>> getUsers() async {
    final response = await dio.get(
      "https://jsonplaceholder.typicode.com/users",
    );

    return (response.data as List)
        .map((e) => ApiModel.fromJson(e))
        .toList();
  }
}