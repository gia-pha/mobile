// import 'dart:convert';
import 'package:dio/browser.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:dio/dio.dart';
// import 'package:http/http.dart' as http;

import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

import 'package:gia_pha_mobile/model/api_response.dart';

class ApiService {
  static ApiService? _instance;
  static const String _defaultBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:46025',
  );

  final String baseUrl;
  late final Dio _dio;
  late final CookieJar _cookieJar;

  factory ApiService({String? baseUrl}) {
    _instance ??= ApiService._internal(baseUrl ?? _defaultBaseUrl);
    return _instance!;
  }

  ApiService._internal(this.baseUrl) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
      validateStatus: (status) => true,
    ));
    if (kIsWeb) {
      _dio.httpClientAdapter = BrowserHttpClientAdapter(withCredentials: true);
    } else {
      _cookieJar = CookieJar(); // Use PersistCookieJar() if needed
      _dio.interceptors.add(CookieManager(_cookieJar));
    }
  }

  Future<ApiResponse> get(String path, {Map<String, String>? headers}) async {
    final response = await _dio.get(path, options: Options(headers: headers));
    return _convertDioResponse(response);
  }

  Future<ApiResponse> post(String path, {Map<String, String>? headers, dynamic data}) async {
    final response = await _dio.post(path, data: data, options: Options(headers: headers));
    return _convertDioResponse(response);
  }

  ApiResponse _convertDioResponse(Response response) {
    return ApiResponse(
      statusCode: response.statusCode ?? 0,
      headers: response.headers.map,
      data: response.data,
    );
  }
}
