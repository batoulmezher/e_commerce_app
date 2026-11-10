import 'package:dio/dio.dart';
import 'package:e_commerce_app/Api/api.dart';

class LoginService {
  Future<dynamic> postLogInData(String email, String password) async {
    try {
      final res = await Api().dio.post(
        'api/auth/login',
        data: {
          "email": email,
          "password": password,
        },
      );

      print("LOGIN STATUS: ${res.statusCode}");
      print("LOGIN BODY: ${res.data}");
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