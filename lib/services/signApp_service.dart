import 'package:dio/dio.dart';
import 'package:e_commerce_app/Api/api.dart';

class SignUpServive {
  Future<dynamic> postSignUpData(
    String email,
    String password,
    String fullName,
  ) async {
    try {
      final res = await Api().dio.post(
        'api/auth/register',
        data: {
          "email": email,
          "password": password,
          "fullName": fullName,
        },
      );

      print("REGISTER STATUS: ${res.statusCode}");
      print("REGISTER BODY: ${res.data}");
      return res.data;
    } on DioException catch (e) {
      final msg = e.response?.data?['detail']
          ?? e.response?.data?['title']
          ?? e.message
          ?? 'خطأ غير معروف';
      throw Exception('${e.response?.statusCode ?? ""} - $msg');
    }
  }
}