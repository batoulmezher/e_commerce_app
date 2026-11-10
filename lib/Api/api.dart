
import 'package:dio/dio.dart';
import 'package:e_commerce_app/Api/app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

class Api {
  final dio = createDio;

  Api._internal();

  static final _singleton = Api._internal();

  factory Api() => _singleton;

  static Dio get createDio {
    var dio = Dio(BaseOptions(
      baseUrl: appConfig,
      receiveTimeout: const Duration(seconds: 60),
      connectTimeout: const Duration(seconds: 25),
      sendTimeout: const Duration(seconds: 25),
    ));

    dio.interceptors.addAll({
      AppInterceptors(dio),
    });
    return dio;
  }
}

class AppInterceptors extends Interceptor {
  final Dio? dio;

  GetStorage box = GetStorage();

  AppInterceptors(this.dio);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = box.read('token');

    if (kDebugMode) {
      print('token is $token');
    }

    options.headers = {
      "Content-Type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer $token"
    };

    return handler.next(options);
  }

  @override
  void onResponse(
    response,
    ResponseInterceptorHandler handler,
  ) {
    print(
      'RESPONSE[${response.statusCode}] => Data: ${response.data}',
    );
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print(
      'ERROR[${err.response!.statusCode}] => PATH: ${err.response!.data}',
    );

    if (err.response!.statusCode == 401) {
      print(
        'ERROR[${err.response!.statusCode}]}',
      );
    } else if (err.response!.statusCode == 403) {
      print(
        'ERROR[${err.response!.statusCode}]}',
      );
    } else if (err.response!.statusCode == 500) {
      print(
        'ERROR[${err.response!.statusCode}]}',
      );
    }

    handler.next(err);

    return null;
  }
}
